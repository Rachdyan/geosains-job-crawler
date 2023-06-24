

quiet <- function(x) { 
  sink(tempfile()) 
  on.exit(sink()) 
  invisible(force(x)) 
} 

get_job_criteria_index <- function(job_criteria, string){
  job_criteria %>% 
    html_text2() %>% 
    str_detect(string) %>%
    which()
} 

get_linkedin <- function(all_jobs_page){
  
  source <- "linkedin"
  
  job_id <- tryCatch({all_jobs_page %>% 
      html_element("div, a") %>% 
      html_attr("data-entity-urn") %>%
      str_after_last(":")}, 
      error = function(e) NA)
  job_id <- ifelse(is_empty(job_id), NA, job_id)
  
  job_url <- glue("https://www.linkedin.com/jobs/view/{job_id}")
  
  job_title <- tryCatch({all_jobs_page %>% 
      html_elements("h3") %>% 
      html_text2()}, 
      error = function(e) NA)
  job_title <- ifelse(is_empty(job_title), NA, job_title)
  
  job_company <- tryCatch({all_jobs_page %>% 
      html_elements("h4") %>% 
      html_text2()}, 
      error = function(e) NA)
  job_company <- ifelse(is_empty(job_company), NA, job_company)
  
  job_location <- tryCatch({all_jobs_page %>% 
      html_elements("div[class *= 'metadata'] > span[class *= 'location']") %>%
      html_text2()}, 
      error = function(e) NA)
  job_location <- ifelse(str_detect(job_location, ", Indonesia$") == FALSE, glue("{job_location}, Indonesia"), job_location)
  job_location <- ifelse(is_empty(job_location), NA, job_location)
  
  job_salary <- tryCatch({all_jobs_page %>% 
      html_elements("div[class *= 'metadata'] > span[class *= 'salary']") %>%
      html_text2()}, 
      error = function(e) NA)
  job_salary <- ifelse(is_empty(job_salary), NA, job_salary)
  
  job_list_date <- tryCatch({all_jobs_page %>% 
      html_elements("div[class *= 'metadata'] > time[class *= 'listdate']") %>%
      html_attr('datetime')}, 
      error = function(e) NA)
  job_list_date <- ifelse(is_empty(job_list_date), NA, job_list_date)
  
  job_info_df <- tryCatch({
    tibble(source = source, job_id, job_url, job_title, job_company, job_location, job_salary, job_list_date)}, 
    error = function(e) tibble(job_id = "Error", job_url = "Error", job_title = NA, job_company = NA, job_location = NA, 
                               job_salary = NA, job_list_date = NA))
}

enrich_linkedin <- function(job_info_df, rD){
  
  url <- job_info_df$job_url
  glue("Getting Job Details for {job_info_df$job_title} - {job_info_df$job_company}") %>% print()
  tryCatch({rD$navigate(url)}, error = function(e) {
    result_df <- cbind(job_info_df, seniority_level = NA, employment_type = NA, industries = NA, job_description = NA, applicant = NA, get_time = NA)
    return(result_df)
  })
  
  Sys.sleep(3)
  webElem <- rD$findElement("css selector", "button[class *= 'show-more']")
  webElem <- webElem$clickElement()
  Sys.sleep(1)
  
  page <- rD$getPageSource()[[1]] %>% 
    read_html() 
  
  keywords <- c("Job ID", "Job Type", "Location", "Categories", "Applications close")
  # Construct the regex pattern
  pattern <- paste0("(?<=\\b", paste(keywords, collapse = "\\b|\\b"), "\\b)\\n\\n")
  
  job_description <- tryCatch({page %>% html_element("div[class *= 'show-more']") %>%
      as.character() %>%
      str_remove_all("\n|\t") %>% 
      str_replace_all('[\"]',  "'") %>%
      str_remove_all("<div class='show-more-less-html__markup show-more-less-html__markup--clamp-after-5          relative overflow-hidden'>|<div class='show-more-less-html__markup relative overflow-hidden'>") %>%
      str_squish() %>%
      str_replace_all("<p><br></p>", "\n\n") %>%
      str_replace_all("</ul>", "\n\n") %>%
      str_remove_all("<div>|</div>|<ul>|</li>|</p>|</ol>|</br>|<span>|</span>") %>%
      str_replace_all("<p>|<ol>|<br>", "\n\n") %>%
      str_replace_all("<li>", "\n • ") %>%
      str_remove_all("•  \n|• \n") %>%
      str_replace_all("  •", " •") %>%
      str_replace_all("(\n{2})\n+", "\n\n")  %>%
      str_replace_all("\n\n</strong>\n", "\n</strong>\n") %>%
      str_replace_all(pattern, "\n")},
      error = function(e) NA)
  job_description <- ifelse(is_empty(job_description), NA, job_description)
  
  job_criteria <- tryCatch({page %>%
      html_elements("ul[class *= 'job-criteria'] > li")}, 
      error = function(e) NA)
  
  applicant <- tryCatch({page %>% 
      html_element("figcaption[class *= applicants]") %>% 
      html_text2()}, 
      error = function(e) NA)
  if(is_empty(applicant)) {
    applicant <- tryCatch({page %>% 
      html_element("span[class *= applicants]") %>% 
      html_text2()}, 
      error = function(e) NA)
  }
  
  applicant <- ifelse(is_empty(applicant), NA, applicant)
  
  get_time <- Sys.time()
  
  if(!all(sapply(job_criteria, genTS::is_empty))){
    seniority_level_index <- job_criteria %>% 
      get_job_criteria_index("Seniority level")
    seniority_level_index <- ifelse(is_empty(seniority_level_index), NA, seniority_level_index)
    
    seniority_level <- ifelse(!is_empty(seniority_level_index), 
                              job_criteria[seniority_level_index] %>% 
                                html_element("span") %>% html_text2(), NA)
    
    employment_type_index <- job_criteria %>% 
      get_job_criteria_index("Employment type")
    employment_type_index <- ifelse(is_empty(employment_type_index), NA, employment_type_index)
    
    employment_type <- ifelse(!is_empty(employment_type_index), 
                              job_criteria[employment_type_index] %>% 
                                html_element("span") %>% html_text2(), NA)
    
    industries_index <- job_criteria %>% 
      get_job_criteria_index("Industries")
    industries_index <- ifelse(is_empty(industries_index), NA, industries_index)
    
    industries <- ifelse(!is_empty(industries_index), 
                         job_criteria[industries_index] %>% 
                           html_element("span") %>% html_text2(), NA)
  } else{
    seniority_level <- NA
    employment_type <- NA
    industries <- NA
  }
  Sys.sleep(sample(2:4, 1))
  result <- cbind(job_info_df, seniority_level, employment_type, industries, job_description, applicant, get_time)
  
}


get_job_criteria_index <- function(job_criteria, string){
  job_criteria %>% 
    html_text2() %>% 
    str_detect(string) %>%
    which()
} 


scrape_send_linkedin <- function(url, bot_token, chat_id, remote = F){
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
    pass_list <- c("ad090add-449b-4da7-be9c-1dd56c1e752f", "a3c4b506-4529-4e5c-801d-bbb31e015f5c", 
                   "906eca4c-234f-4ce8-8c7a-26371a42105b", "38c1a776-e9a0-4e99-8098-36a6265a0286",
                   "95bfbe80-2f95-4d16-9235-f2da31b309ce", "766f55f3-d210-4a59-bd82-8c66fe8b2115", 
                   "7cf72936-bf04-4d63-b5d0-9925a96caa04", "2a843f22-78f1-4ca3-8a0e-d84b390a8b85",
                   "b51a6828-9abf-4924-aa13-a128a47b6bc5", "fe65069d-fc3a-4c21-9a2a-76a6431815f7",
                   "0eac964f-5397-4679-9943-1886d94e1d8b", "b63fbd3f-d17c-4e6b-ba7e-701bb9d025f3",
                   "2472c5b6-122a-4a96-ab04-e8342d0c1521", "1521db3d-265d-47ed-b944-d4bc317b832b",
                   "19eb35e5-a1cc-491b-b325-e98ce374869b", "8db9ad0f-dfc9-4586-837f-16802c034a26",
                   "9400a235-740d-4bf1-a8a9-98b23c6e9562", "47a49ee0-b981-4afe-bf60-481fa8de5d9a")
    
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
  
  last_height = 0
  repeat {   
    rD$executeScript("window.scrollTo(0,document.body.scrollHeight);")
    Sys.sleep(3) #delay by 3sec to give chance to load. 
    
    # Updated if statement which breaks if we can't scroll further 
    new_height = rD$executeScript("return document.body.scrollHeight")
    if(unlist(last_height) == unlist(new_height)) {
      break
    } else {
      last_height = new_height
    }
  }
  
  glue("Getting Jobs Info from {url}") %>% message()
  page <- rD$getPageSource()[[1]] %>% 
    read_html()
  all_jobs_page <- page %>% html_elements("ul[class *= 'results-list'] > li")
  all_jobs_info <- map_dfr(all_jobs_page, get_linkedin)
  
  job_scraped <- read_csv("./data/job_scraped.csv", col_types = "ccccccc")
  
  new_jobs <- all_jobs_info %>% 
    anti_join(job_scraped, by = join_by("source","job_id", "job_title", "job_company"))
  
  if(nrow(new_jobs) == 0){
    glue("No new jobs from {url}") %>% message()
    rD$close()
    return(NA)
  } else{
    glue("Total New Jobs: {nrow(new_jobs)}") %>% message()
    new_jobs_detail <- new_jobs %>%
      group_nest(row_number()) %>% 
      pull(data) %>%
      map_dfr(enrich_linkedin, rD)
  }
  
  message("Appending new jobs into the existing csv..")
  write.table(new_jobs_detail,
              file = "./data/job_scraped.csv", 
              sep = ",",
              append = T,
              row.names = F,
              col.names = F)
  
  rD$close()
  
  posted_df <- new_jobs_detail %>%
    group_nest(row_number()) %>% 
    pull(data) %>%
    map_dfr(possibly(send_message, otherwise = tibble(source = "indeed", job_url = "error", job_title = "error", job_company = "error", posted_at = Sys.time() + years(50))), 
            bot_token = bot_token, chat_id = chat_id)
  
  message("Appending posted job info to the existing csv..")
  write.table(poosted_df,
              file = "./data/job_posted.csv", 
              sep = ",",
              append = T,
              row.names = F,
              col.names = F)
  
  message("Done!")
}



