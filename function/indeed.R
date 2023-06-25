

quiet <- function(x) { 
  sink(tempfile()) 
  on.exit(sink()) 
  invisible(force(x)) 
} 


get_indeed <- function(all_jobs_page){
  
  source <- "indeed"
  
  job_title <- tryCatch({all_jobs_page %>% 
      html_element("h2") %>% 
      html_text2()},
      error = function(e) NA)
  job_title <- ifelse(is_empty(job_title), NA, job_title)
  
  
  job_id <- tryCatch({all_jobs_page %>%
      html_element("a") %>%
      html_attr("data-jk")},
      error = function(e) NA)
  job_id <- ifelse(is_empty(job_id), NA, job_id)
  
  job_url <- glue("https://id.indeed.com/viewjob?jk={job_id}")
  
  
  job_company <- tryCatch({all_jobs_page %>% 
      html_element("div[class *= 'company']") %>% 
      html_element("span[class *= 'Name']") %>%
      html_text2()},
      error = function(e) NA)
  job_company <- ifelse(is_empty(job_company), NA, job_company)
  
  
  job_location <- tryCatch({all_jobs_page %>% 
      html_element("div[class *= 'company']") %>% 
      html_element("div[class *= 'Location']") %>%
      html_text2() %>%
      str_remove("\\+.+")},
      error = function(e) NA)
  job_location <- ifelse(is_empty(job_location), NA, job_location)
  
  
  job_salary <- tryCatch({all_jobs_page %>% 
      html_element("div[class *= 'Container']") %>% 
      html_element("div[class *= 'salary']") %>%
      html_text2() %>%
      str_before_first(" per") %>%
      str_replace_all("Rp. ", "IDR") %>%
      str_replace_all("\\.", ",")},
      error = function(e) NA)
  job_salary <- ifelse(is_empty(job_salary), NA, job_salary)
  
  
  employment_type <- tryCatch({all_jobs_page %>% 
      html_elements("div[class *= 'Container'] > div") %>% 
      tail("1") %>% 
      html_text2() %>%
      str_remove("\\+.+")},
      error = function(e) NA)
  employment_type <- ifelse(is_empty(employment_type), NA, employment_type)
  employment_type <- ifelse(str_detect(employment_type, "[0-9]"), NA, employment_type)
  
  posted_ago_raw <- tryCatch({all_jobs_page %>% 
      html_element("table[class *= 'jobCardShelfContainer']") %>%
      html_element("span[class *= 'date']") %>%
      html_text2() %>% 
      str_after_first("Active |Posted ")},
      error = function(e) NA)
  posted_ago_raw <- ifelse(is_empty(posted_ago_raw), NA, posted_ago_raw)
  
  if(!is_empty(posted_ago_raw) && str_detect(posted_ago_raw, "30+")){
    job_list_date <- Sys.Date() %>% 
      format("%Y-%m") %>%
      ym() - months(1) 
  } else if(!is_empty(posted_ago_raw)){
    days_ago <- str_extract(posted_ago_raw, "\\d+") %>%
      as.numeric()
    
    job_list_date <- Sys.Date() %>% 
      ymd() - days(days_ago) 
  } else{
    job_list_date <- NA
  }
  
  job_info_df <- tryCatch({
    tibble(source = source, job_id, job_url, job_title, job_company, job_location, job_salary, employment_type,  job_list_date)}, 
    error = function(e) tibble(job_id = "Error", job_url = "Error", job_title = NA, job_company = NA, job_location = NA, 
                               job_salary = NA, job_list_date = NA))
}

enrich_indeed <- function(job_info_df, rD){
  url <- job_info_df$job_url
  glue("Getting Job Details for {job_info_df$job_title} - {job_info_df$job_company}") %>% print()
  
  tryCatch({rD$navigate(url)}, error = function(e) {
    result_df <- cbind(job_info_df, seniority_level = NA, industries = NA, job_description = NA, applicant = NA, get_time = NA)
    return(result_df)
  })
  
  Sys.sleep(3)
  
  page <- rD$getPageSource()[[1]] %>% 
    read_html()
  
  description_raw <- tryCatch({page %>% 
      html_element("div[id='jobDescriptionText']")},
      error = function(e) NA)
  
  job_description <- tryCatch({description_raw %>%
      as.character()  %>%
      str_remove_all("\n|\t") %>% 
      str_replace_all('[\"]',  "'") %>%
      str_squish() %>%
      str_replace_all("<p><br></p>", "\n\n") %>%
      str_replace_all("</ul>", "\n\n") %>%
      str_replace_all("<(h[1-9]).*?>", "<strong>") %>%
      str_replace_all("</(h[1-9])>", "</strong>") %>%
      str_remove_all("<div.*?>|<div>|</div>|<ul.*?>|<ul>|</li>|</p>|</ol>|</br>|<span.*?>|<span>|</span>") %>%
      str_replace_all("<p>|<ol>|<br>", "\n\n") %>%
      str_replace_all("<li>|<li.*?>", "\n • ") %>%
      str_replace_all("\\n\\s+\\n", "\n\n") %>%
      str_replace_all("\n\n<b>\n\n", "<b>\n\n") %>%
      str_remove_all("•  \n|• \n|• \n\n") %>%
      str_replace_all("  •", " •") %>%
      str_replace_all("(\n{2})\n+", "\n\n")  %>%
      str_replace_all("\n\n</strong>\n", "\n</strong>\n")}, 
      error = function(e) NA)
  job_description <- ifelse(is_empty(job_description), NA, job_description)
  
  seniority_level <- NA
  applicant <- NA
  get_time <- Sys.time()
  
  new_job_list_date <- tryCatch({page %>% 
      html_elements("script") %>%
      .[4] %>%
      html_text2() %>%
      fromJSON() %>%
      .["datePosted"] %>%
      unlist() %>%
      unname() %>%
      as.Date()}, 
      error = function(e) NA)
  
  if(is_empty(new_job_list_date)) new_job_list_date <- job_info_df$job_list_date
  
  ### INDUSTRIES
  company_industry_indeed <- read.csv("./data/company_industry_indeed.csv")
  company_industry_indeed <- company_industry_indeed %>% distinct()

  
  job_info_df <- job_info_df %>% 
    left_join(company_industry_indeed) %>%
    relocate(industries, .after = employment_type)
  
  if(is_empty(job_info_df$industries)){
    company_link <- page %>% 
      html_element("div[data-company-name *= 'true'] > a") %>%
      html_attr("href")
    
    rD$navigate(company_link)
    Sys.sleep(3)
    
    page <- rD$getPageSource()[[1]] %>% 
      read_html()
    
    new_industries <- tryCatch({page %>% 
        html_element("li[data-testid *= 'industry']") %>%
        html_elements("div") %>%
        tail(1) %>% 
        html_text2()}, 
        error = function(e) "Not Available")
    
    if(is_empty(new_industries)) new_industries <- "Not Available"
    
    new_company_industry <- cbind(job_info_df$job_company, new_industries)
    
    glue("Writing new company industry for {job_info_df$job_company} - {new_industries}") %>% message()
    
    write.table(new_company_industry,
                file = "./data/company_industry_indeed.csv", 
                sep = ",",
                append = T,
                row.names = F,
                col.names = F)
    
  } else{
    new_industries <- job_info_df$industries
  }
  
  job_info_df <- job_info_df %>% mutate(job_list_date = new_job_list_date, industries = new_industries)
  
  result_df <- cbind(job_info_df, seniority_level, job_description, applicant, get_time) %>%
    relocate(employment_type, .after = seniority_level) %>%
    select("source", "job_id", "job_url", "job_title", "job_company", 
           "job_location", "job_salary", "job_list_date", "seniority_level", 
           "employment_type", "industries", "job_description", "applicant", 
           "get_time")
}


scrape_send_indeed <- function(url, bot_token, chat_id, remote = F, all_pages = F){
  message("Starting Machine")
  extraCap <- list(
    chromeOptions = list(
      args = c('--window-size=1280,800',
               '--no-sandbox',
               '--disable-blink-features=AutomationControlled',
               '--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36'),
      excludeSwitches = list("enable-automation"),
      prefs = list(`profile.default_content_settings.popups` = 0,
                   useAutomationExtension = FALSE
      )
    )
  )
  
  if(remote){
    user_list <- c("oauth-rachdyannaufal-304a1", "oauth-rachdyannaufal2-18d46", 
                   "oauth-rachdyannaufal3-57799", "oauth-rachdyannaufal4-63290", 
                   "oauth-rachdyannaufal5-436a6","oauth-yardsupplyapp-288b8", 
                   "oauth-rachdyannaufal6-b45ce", "oauth-rachdyannaufal7-a1208",
                   "oauth-arrow1336343rachdyan-9ed03", "oauth-arrowrq1336343rachdyan-f28a9", 
                   "oauth-arrowrqhl1336343rachdyan-ae7e3","oauth-naufalrachdyan-fd915", 
                   "oauth-arrow3493026chikabeladina-f200e", "rachdyanz",
                   "oauth-cbeladina-d6a2d", "oauth-rachdyannaufal8-a966e",
                   "oauth-rachdyannaufal9-8c10e", "oauth-rachdyannaufal10-8140c")
    # pass_list <- c("ad090add-449b-4da7-be9c-1dd56c1e752f", "a3c4b506-4529-4e5c-801d-bbb31e015f5c", 
    #                "906eca4c-234f-4ce8-8c7a-26371a42105b", "38c1a776-e9a0-4e99-8098-36a6265a0286",
    #                "95bfbe80-2f95-4d16-9235-f2da31b309ce", "766f55f3-d210-4a59-bd82-8c66fe8b2115", 
    #                "7cf72936-bf04-4d63-b5d0-9925a96caa04", "2a843f22-78f1-4ca3-8a0e-d84b390a8b85",
    #                "b51a6828-9abf-4924-aa13-a128a47b6bc5", "fe65069d-fc3a-4c21-9a2a-76a6431815f7",
    #                "0eac964f-5397-4679-9943-1886d94e1d8b", "b63fbd3f-d17c-4e6b-ba7e-701bb9d025f3",
    #                "2472c5b6-122a-4a96-ab04-e8342d0c1521", "1521db3d-265d-47ed-b944-d4bc317b832b",
    #                "19eb35e5-a1cc-491b-b325-e98ce374869b", "8db9ad0f-dfc9-4586-837f-16802c034a26",
    #                "9400a235-740d-4bf1-a8a9-98b23c6e9562", "47a49ee0-b981-4afe-bf60-481fa8de5d9a")
    pass_list <- Sys.getenv("SL_PASS") %>% str_split(";") %>% unlist()
    
    n_random <- sample(length(user_list), 1)
    user <- user_list[n_random]
    pass <- pass_list[n_random]
    ip <- paste0(user, ':', pass, "@ondemand.saucelabs.com")
    
    rD <- tryCatch({remoteDriver$new(
      remoteServerAddr = ip,
      port = 80,
      browserName = "chrome",
      version = "latest",
      platform = "Windows 11",
      extraCapabilities = extraCap
    )}, error = function(e) NA)
    
    tryCatch({quiet(suppressMessages(rD$open()))}, error = function(e) NA)
    message("Success Opening the remote machine")
  } else {
    driver <- quiet(suppressMessages(
      rsDriver(browser="chrome", port=netstat::free_port(), chromever = NULL, extraCapabilities = extraCap))
    )
    rD <- driver[["client"]]
  }
  
  rD$navigate(url)
  Sys.sleep(3)
  
  glue("Getting Jobs Info from {url}") %>% message()
  
  page <- rD$getPageSource()[[1]] %>% 
    read_html()
  all_jobs_raw <- page %>% html_elements("ul[class *= 'Results'] > li > div[class *= 'card']")
  all_jobs_info <- map_dfr(all_jobs_raw, get_indeed)
  
  if(all_pages){
    pagination <- page %>% html_element("nav[aria-label *= 'pagination']") %>% html_elements("div")
    
    n_next_page <- length(pagination) - 2
    
    glue("There are total {n_next_page} next pages") %>% message()
    
    if(n_next_page <= 0){
      all_jobs_info <- all_jobs_info
    } else{
      next_page_links <- NULL
      
      for(i in 1:n_next_page){
        page_link <- glue("{url}&start={i}0")
        glue("Getting Jobs Info from {page_link}") %>% message()
        rD$navigate(page_link)
        Sys.sleep(3)
        page <- rD$getPageSource()[[1]] %>% 
          read_html()
        
        jobs_raw <- page %>% html_elements("ul[class *= 'Results'] > li > div[class *= 'card']")
        jobs_info <- map_dfr(jobs_raw, get_indeed)
        
        all_jobs_info <- rbind(all_jobs_info, jobs_info)
      }
    }
  }
  
  job_scraped <- read_csv("./data/job_scraped.csv", col_types = "ccccccc")
  
  new_jobs <- all_jobs_info %>% 
    anti_join(job_scraped, by = join_by("source", "job_id", "job_title", "job_company"))
  
  if(nrow(new_jobs) == 0){
    glue("No new jobs from {url}") %>% message()
    rD$close()
    return(NA)
  } else{
    glue("Total New Jobs: {nrow(new_jobs)}") %>% message()
    new_jobs_detail <- new_jobs %>%
      group_nest(row_number()) %>% 
      pull(data) %>%
      map_dfr(enrich_indeed, rD)
  }
  
  message("Appending new jobs into the existing csv..")
  write.table(new_jobs_detail,
              file = "./data/job_scraped.csv", 
              sep = ",",
              append = T,
              row.names = F,
              col.names = F)
  
  rD$close()
  
  message("Sending Message..")
  posted_df <- new_jobs_detail %>%
      filter(!str_detect(job_title, "Developer|Guru|Data Analyst|Data Engineer") %>% replace_na(TRUE)) %>%
      group_nest(row_number()) %>% 
      pull(data) %>%
      map_dfr(possibly(send_message, otherwise = tibble(source = "indeed", job_url = "error", job_title = "error", job_company = "error", posted_at = Sys.time() + years(50))), 
              bot_token = bot_token, chat_id = chat_id)
  
  message("Appending posted job info to the existing csv..")
  write.table(posted_df,
              file = "./data/job_posted.csv", 
              sep = ",",
              append = T,
              row.names = F,
              col.names = F)
  
  message("Done!")
}

