
safe_read_html <- safely(read_html, quiet = F)

user_agent_list <- c("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36",
                     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/109.0",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:108.0) Gecko/20100101 Firefox/108.0",
                     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36",
                     "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0",
                     "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36",
                     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.2 Safari/605.1.15",
                     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/109.0",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                     "Mozilla/5.0 (X11; Linux x86_64; rv:108.0) Gecko/20100101 Firefox/108.0",
                     "Mozilla/5.0 (Windows NT 10.0; rv:109.0) Gecko/20100101 Firefox/109.0",
                     "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36",
                     "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0",
                     "Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0",
                     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.3 Safari/605.1.15",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.61",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36 OPR/94.0.0.0",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.78",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.70",
                     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Safari/605.1.15",
                     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:108.0) Gecko/20100101 Firefox/108.0",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.55",
                     "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36",
                     "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:108.0) Gecko/20100101 Firefox/108.0",
                     "Mozilla/5.0 (Windows NT 10.0; rv:108.0) Gecko/20100101 Firefox/108.0",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36 Edg/108.0.1462.76",
                     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 YaBrowser/22.11.5.715 Yowser/2.5 Safari/537.36",
                     "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36",
                     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36",
                     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6.1 Safari/605.1.15",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/110.0",
                     "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36 OPR/93.0.0.0",
                     "Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101 Firefox/102.0",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101 Firefox/107.0",
                     "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36",
                     "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36",
                     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 YaBrowser/22.11.7.42 Yowser/2.5 Safari/537.36",
                     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Safari/605.1.15",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36 Edg/110.0.1587.41",
                     "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:109.0) Gecko/20100101 Firefox/109.0",
                     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36 Edg/108.0.1462.54",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 YaBrowser/23.1.1.1138 Yowser/2.5 Safari/537.36",
                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.69",
                     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Safari/605.1.15",
                     "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36",
                     "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:108.0) Gecko/20100101 Firefox/108.0",
                     "Mozilla/5.0 (X11; Linux x86_64; rv:107.0) Gecko/20100101 Firefox/107.0")



get_disnakerja <- function(all_jobs_page, industries){
  
  source <- "disnakerja"
  
  job_id <- tryCatch({all_jobs_page %>%
      html_attr("id") %>%
      str_after_first("-")},
      error = function(e) NA)
  job_id <- ifelse(is_empty(job_id), NA, job_id)
  
  job_url <- tryCatch({all_jobs_page %>% 
      html_element("a") %>%
      html_attr("href")},
      error = function(e) NA)
  job_url <- ifelse(is_empty(job_url), NA, job_url)
  
  job_company <- tryCatch({all_jobs_page %>% 
      html_element("a") %>%
      html_attr("title")},
      error = function(e) NA)
  job_company <- ifelse(is_empty(job_company), NA, job_company)
  
  
  job_info_df <- tryCatch({
    tibble(source = source, job_id, job_url, job_company, industries = industries)}, 
    error = function(e) tibble(source = source, job_id = "Error", job_url = "Error", job_title = NA, job_company = NA, industries = industries))
  
}


enrich_disnakerja <- function(job_info_df){
  url <- job_info_df$job_url
  glue("Getting Job Details for {job_info_df$job_company}") %>% print()
  
  Sys.sleep(1)
  
  read_page <- GET(url, add_headers('user-agent' = sample(user_agent_list, 1)))  %>%
    safe_read_html()
  
  page <- read_page$result
  
  if(!is.null(page)){
    
    job_title <- tryCatch({page %>%
        html_element("div[class='entry-meta'] > span") %>%
        html_text2() %>%
        paste0(" Posisi")}, 
        error = function(e) NA)
    job_title <- ifelse(is_empty(job_title), NA, job_title)
    
    specs_raw <- tryCatch({page %>% 
        html_element("div[id = 'specs'] > ul") %>%
        html_elements("li")}, 
        error = function(e) NA)
    if(all(sapply(specs_raw, genTS::is_empty))){
      specs_raw <- NA
    } 
    
    job_location <- tryCatch({specs_raw[3] %>% 
        html_text2() %>%
        str_remove_all("Lokasi:") %>%
        str_squish()}, 
        error = function(e) NA)
    job_location <- ifelse(is_empty(job_location), NA, job_location)
    
    employment_type <-  tryCatch({specs_raw[4] %>%
        html_text2() %>%
        str_remove_all("Tipe Pekerjaan:") %>%
        str_squish()}, 
        error = function(e) NA)
    employment_type <- ifelse(is_empty(employment_type), NA, employment_type)
    
    seniority_level <- tryCatch({specs_raw[6] %>%
        html_text2() %>%
        str_remove_all("Pengalaman:") %>%
        str_squish()}, 
        error = function(e) NA)
    seniority_level <- ifelse(is_empty(seniority_level), NA, seniority_level)
    
    job_list_date <- tryCatch({specs_raw[1] %>%
        html_element("time[itemprop = 'datePublished']") %>%
        html_attr("datetime") %>%
        as.Date()}, 
        error = function(e) NA)
    if(is_empty(job_list_date)){
      job_list_date <- NA
    }
    
    description_raw <- tryCatch({page %>%
        html_element("div[id = 'description']") %>% 
        html_children() %>%
        head(-4) %>%
        tail(-2)}, 
        error = function(e) NA)
    
    job_description <- tryCatch({description_raw %>%
        as.character() %>%
        str_flatten()  %>%
        str_remove_all("\n|\t") %>% 
        str_replace_all('[\"]',  "'") %>%
        str_squish() %>%
        str_replace_all("<p><br></p>", "\n\n") %>%
        str_replace_all("</ul>", "\n\n") %>%
        str_replace_all("<(h[1-9]).*?>", "<strong>") %>%
        str_replace_all("</(h[1-9])>", "</strong>") %>%
        str_remove_all("<div.*?>|<div>|</div>|<ul.*?>|<ul>|</li>|</p>|</ol>|</br>|<span.*?>|<span>|</span>|<script.*?>|</script>|<ins.*?>|</ins>|<hr.*?>|</hr>|<img.*?>|</img>|<noscript>|</noscript>|<iframe.*?>|</iframe>|<table.*?>|</table>|<tbody.*?>|</tbody>") %>%
        str_remove_all(fixed("(adsbygoogle = window.adsbygoogle || []).push({});")) %>%
        str_remove_all("<!--.*?-->") %>%
        str_replace_all("<tr>|</tr>|<td.*?>|</td>", "\n") %>%
        str_replace_all("<p.*?>|<ol>|<br>", "\n\n") %>%
        str_replace_all("<li>|<li.*?>", "\n • ") %>%
        str_replace_all("\\n\\s+\\n", "\n\n") %>%
        str_replace_all("\n\n<b>\n\n", "<b>\n\n") %>%
        str_remove_all("•  \n|• \n|• \n\n") %>%
        str_replace_all("  •", " •") %>%
        str_replace_all("(\n{2})\n+", "\n\n")  %>%
        str_replace_all("\n\n</strong>\n", "\n</strong>\n")}, 
        error = function(e) NA)
    job_description <- ifelse(is_empty(job_description), NA, job_description)
    
    job_salary <- NA
    applicant <- NA
    get_time <- Sys.time()
    
    result_df <- tryCatch({cbind(job_info_df, job_title, job_location, job_salary, job_list_date, seniority_level, job_description, employment_type, applicant, get_time) %>%
        select("source", "job_id", "job_url", "job_title", "job_company", 
               "job_location", "job_salary", "job_list_date", "seniority_level", 
               "employment_type", "industries", "job_description", "applicant", 
               "get_time")},
        error = function(e) {
          cbind(job_info_df, job_location = NA, job_salary = NA, job_list_date = NA, seniority_level = NA, job_description = "Error", employment_type = NA, applicant = NA, get_time = NA) %>%
            select("source", "job_id", "job_url", "job_title", "job_company", 
                   "job_location", "job_salary", "job_list_date", "seniority_level", 
                   "employment_type", "industries", "job_description", "applicant", 
                   "get_time")
        })
    
  } else{
    error_message <- read_page$error %>% as.character()
    result_df <- cbind(job_info_df, job_location = error_message, job_salary = NA, job_list_date = error_message, seniority_level = NA, job_description = error_message, employment_type = NA, applicant = NA, get_time = NA) %>%
      select("source", "job_id", "job_url", "job_title", "job_company", 
             "job_location", "job_salary", "job_list_date", "seniority_level", 
             "employment_type", "industries", "job_description", "applicant", 
             "get_time")
  }
  
}


scrape_send_disnakerja <- function(url, bot_token, chat_id){
  
  read_page <- GET(url, add_headers('user-agent' = sample(user_agent_list, 1)))  %>%
    safe_read_html()
  page <- read_page$result
  
  all_jobs_page <- page %>% 
    html_element("div[id *= 'site-container']") %>% 
    html_element("div[id *= 'primary'] > div") %>%
    html_element("main > div") %>%
    html_elements("article")
  
  industries <- page %>% 
    html_element("div[id *= 'site-container']") %>% 
    html_element("div[id *= 'primary'] > div") %>%
    html_element("h1 > span") %>%
    html_text2()
  
  all_jobs_info <-  map_dfr(all_jobs_page, get_disnakerja, industries)
  
  job_scraped <- read_csv("./data/job_scraped.csv", col_types = "ccccccc")
  
  new_jobs <- all_jobs_info %>% 
    anti_join(job_scraped, by = join_by("source","job_id", "job_company"))
  
  if(nrow(new_jobs) == 0){
    glue("No new jobs from {url} \n") %>% message()
    return(NA)
  } else{
    glue("Total New Jobs: {nrow(new_jobs)}") %>% message()
    new_jobs_detail <-  new_jobs %>% 
      group_nest(row_number()) %>% 
      pull(data) %>%
      map_dfr(enrich_disnakerja) %>%
      select(source, job_id, job_url, job_title, job_company, job_location, job_salary, job_list_date, seniority_level, 
             employment_type, industries, job_description, applicant, get_time)
  }
  
  message("Appending new jobs into the existing csv..")
  write.table(new_jobs_detail,
              file = "./data/job_scraped.csv", 
              sep = ",",
              append = T,
              row.names = F,
              col.names = F)
  
  posted_df <- new_jobs_detail %>%
    group_nest(row_number()) %>% 
    pull(data) %>%
    map_dfr(send_message, bot_token = bot_token, chat_id = chat_id)
  
  message("Appending posted job info to the existing csv..")
  write.table(posted_df,
              file = "./data/job_posted.csv", 
              sep = ",",
              append = T,
              row.names = F,
              col.names = F)
  
  message("Done!")
  
}