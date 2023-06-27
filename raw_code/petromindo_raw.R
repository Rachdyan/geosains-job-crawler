library(unmplymnt)
library(jsonlite)
library(rvest)
library(httr)
library(janitor)
library(tidyr)
library(lubridate)
library(purrr)
library(dplyr)
library(stringr)
library(genTS)
library(glue)
library(telegram.bot)
library(strex)


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

url <- 'https://www.petromindo.com/job-gallery/category/mining?page=1'
url <- "https://www.petromindo.com/job-gallery/category/oil-gas"


read_page <- GET(url, add_headers('user-agent' = sample(user_agent_list, 1)))  %>%
  safe_read_html()

page <- read_page$result

all_jobs <- page %>% html_elements("article")
industries <- page %>% 
  html_elements("main > section > div > div[class *= 'row'] > div > div > div > div > div > div") %>%
  .[2] %>%
  html_element("strong") %>%
  html_text2()
all_jobs_info <- map_dfr(all_jobs, get_petromindo, industries)



url <- all_jobs_info[sample(nrow(all_jobs_info), 1), ]$job_url

job_info_df <- all_jobs_info[sample(nrow(all_jobs_info), 1), ]

enrich_petromindo <- function(job_info_df){
  url <- job_info_df$job_url
  glue("Getting Job Details for {job_info_df$job_title} - {job_info_df$job_company}") %>% print()
  
  Sys.sleep(1)
  
  read_page <- GET(url, add_headers('user-agent' = sample(user_agent_list, 1)))  %>%
    safe_read_html()
  
  page <- read_page$result
  
  if(!is.null(page)){
  
  location <- c("Aceh", "Sumatera Utara", "Sumatera Barat", "Riau", "Jambi", 
                "Sumatera Selatan", "Bengkulu", "Lampung", "Kepulauan Bangka Belitung", 
                "Kepulauan Riau", "Jakarta", "Jawa Barat", "Jawa Tengah", 
                "Yogyakarta", "Jawa Timur", "Banten", "Bali ", "Nusa Tenggara Barat", 
                "Nusa Tenggara Timur", "Kalimantan Barat", "Kalimantan Tengah", 
                "Kalimantan Selatan", "Kalimantan Timur", "Kalimantan Utara", 
                "Sulawesi Utara", "Sulawesi Tengah", "Sulawesi Selatan", "Sulawesi Tenggara", 
                "Gorontalo", "Sulawesi Barat", "Maluku", "Maluku Utara", "Papua Barat", 
                "Papua", "Pontianak", "Banjarmasin", "Samarinda", "Balikpapan", "Palangkaraya", "Banjarbaru",
                "Tarakan", "Sanggau")
  
  desc_text <- tryCatch({page %>%
    html_element("div[class *= 'col-12 col-md-8'] > article > div") %>%
    html_text2()}, 
    error = function(e) NA)
  desc_text <- ifelse(is_empty(desc_text), NA, desc_text)
  
  count_province <- str_count(desc_text, province)
  
  if(sum(count_province == max(count_province)) > 1){
    job_location <- NA
  } else{
    job_location <- tryCatch({province[which.max(count_province)] %>% 
        str_squish()},
        error = function(e) NA)
    job_location <- ifelse(is_empty(job_location), NA, job_location)
  }
  
  job_salary <- NA
  
  job_list_date <- tryCatch({page %>% 
      html_element("header[class *='header'] > p > span") %>%
      html_text2() %>%
      str_after_first(": ") %>%
      mdy() %>%
      as.Date()},
      error = function(e) NA)
  if(is_empty(job_list_date)) job_list_date <- NA
  
  employment_type <- NA
  seniority_level <- NA
  
  description_raw <- tryCatch({page %>% 
      html_element("div[class *= 'container'] > div[class *= 'row'] > div > article > div")},
      error = function(e) NA)
  
  
  job_description <- tryCatch({description_raw %>%
      html_elements("p") %>% 
      as.character() %>%
      str_flatten()  %>%
      str_remove_all("\n|\t") %>% 
      str_replace_all('[\"]',  "'") %>%
      str_squish() %>%
      str_replace_all("<p><br></p>", "\n\n") %>%
      str_replace_all("</ul>", "\n\n") %>%
      str_replace_all("<(h[1-9]).*?>", "<strong>") %>%
      str_replace_all("</(h[1-9])>", "</strong>") %>%
      str_remove_all("<div.*?>|<div>|</div>|<ul.*?>|<ul>|</li>|</p>|</ol>|</br>|<span.*?>|<span>|</span>") %>%
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
  
  applicant <- NA
  get_time <- Sys.time()
  
  result_df <- tryCatch({cbind(job_info_df, job_location, job_salary, job_list_date, seniority_level, job_description, employment_type, applicant, get_time) %>%
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





# 
# bot_token <- "6224206664:AAEJuMYHxmqwl9dIda6cst3K_vpr_Xo2GAE"
# chat_id <- 1415309056
# # 
# bot <- Bot(token = bot_token)
#  bot$sendMessage(chat_id = 1415309056, text = job_description2, parse_mode = "html")
# 





all_jobs_page <- all_jobs[1]

get_petromindo <- function(all_jobs_page, industries){
  
  source <- "petromindo"
  
  job_id <- tryCatch({all_jobs_page %>%
    html_attr("id") %>%
    str_after_first("-")},
    error = function(e) NA)
  job_id <- ifelse(is_empty(job_id), NA, job_id)
  
  job_company <- tryCatch({all_jobs_page %>%
    html_attr("title") %>% 
    str_before_first(";")},
    error = function(e) NA)
  job_company <- ifelse(is_empty(job_company), NA, job_company)
  
  job_title <- tryCatch({all_jobs_page %>%
    html_attr("title") %>% 
    str_after_first("; ") %>% 
    str_squish() %>%
    str_replace("2 of 2 ads", "(2)") %>%
    str_replace("1 of 2 ads", "(1)") %>% 
    str_remove_all(";")},
    error = function(e) NA)
  job_title <- ifelse(is_empty(job_title), NA, job_title)
  
  job_url <- tryCatch({all_jobs_page %>% 
    html_elements("a") %>%
    html_attr("href")},
    error = function(e) NA)
  job_url <- ifelse(is_empty(job_url), NA, job_url)
  
  job_info_df <- tryCatch({
    tibble(source = source, job_id, job_url, job_title, job_company, industries = industries)}, 
    error = function(e) tibble(job_id = "Error", job_url = "Error", job_title = NA, job_company = NA))
}

