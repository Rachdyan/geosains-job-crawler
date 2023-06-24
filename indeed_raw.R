source("./function/linkedin.R")
library(RSelenium)
library(dplyr)
library(rvest)
library(glue)
library(purrr)
library(genTS)
library(stringr)
library(netstat)
library(strex)
library(readr)
library(telegram.bot)
library(lubridate)
library(jsonlite)

tez <- indeed("geologist")


url <- "https://id.indeed.com/jobs?q=geology&sort=date&start=0"
url <- "https://id.indeed.com/jobs?q=geologi&sort=date&start=0"
url <- "https://id.indeed.com/jobs?q=geologist&sort=date&start=0"
url <- "https://id.indeed.com/jobs?q=mine&sort=date&start=0"
url <- "https://id.indeed.com/jobs?q=mining&sort=date&start=0"
url <- "https://id.indeed.com/jobs?q=oil+and+gas&sort=date&start=0"
url <- "https://id.indeed.com/jobs?q=migas&sort=date&start=0"
url <- "https://id.indeed.com/jobs?q=geodesi&sort=date&start=0"
url <- "https://id.indeed.com/jobs?q=tambang&sort=date&start=0"
url <- 'https://id.indeed.com/jobs?q="gis"&sort=date&start=0'




url <- "https://id.indeed.com/jobs?q=gis&sort=date&start=0"


url <- "https://id.indeed.com/?from=gnav-jobsearch--indeedmobile"


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




driver <- quiet(suppressMessages(
  rsDriver(browser="chrome", port=netstat::free_port(), chromever = NULL, extraCapabilities = extraCap))
)
rD <- driver[["client"]]

rD$navigate(url)





## GET PAGE
page <- rD$getPageSource()[[1]] %>% 
  read_html()

all_jobs_raw <- page %>% html_elements("ul[class *= 'Results'] > li > div[class *= 'card']")
all_jobs_info <- map_dfr(all_jobs_raw, get_indeed)

if(all_page = T){
  pagination <- page %>% html_element("nav[aria-label *= 'pagination']") %>% html_elements("div")
  
  n_next_page <- length(pagination) - 2
  next_page_links <- NULL
  
  for(i in 1:n_next_page){
    page_link <- glue("https://id.indeed.com/jobs?q=mine&start={i}0")
    rD$navigate(page_link)
    Sys.sleep(3)
    page <- rD$getPageSource()[[1]] %>% 
      read_html()
    
    jobs_raw <- page %>% html_elements("ul[class *= 'Results'] > li > div[class *= 'card']")
    jobs_info <- map_dfr(jobs_raw, get_indeed)
    
    all_jobs_info <- rbind(all_jobs_info, jobs_info)
  }
}


## COBA FILL INDUSTRY
company_industry_indeed <- read.csv("./data/company_industry_indeed.csv")

all_jobs_info <- all_jobs_info %>% 
  left_join(company_industry_indeed) %>%
  relocate(industries, .after = employment_type)



### GET INFO
job_xml <- all_jobs_raw[3]

job_title <- job_xml %>% html_element("h2") %>% html_text2()
job_id <- job_xml %>% html_element("a") %>% html_attr("data-jk")
job_url <- glue("https://id.indeed.com/viewjob?jk={job_id}")


job_company <- job_xml %>% 
  html_element("div[class *= 'company']") %>% 
  html_element("span[class *= 'Name']") %>%
  html_text2()

job_location <- job_xml %>% 
  html_element("div[class *= 'company']") %>% 
  html_element("div[class *= 'Location']") %>%
  html_text2()

job_salary <- job_xml %>% 
  html_element("div[class *= 'Container']") %>% 
  html_element("div[class *= 'salary']") %>%
  html_text2() %>%
  str_before_first(" per") %>%
  str_replace_all("Rp. ", "IDR") %>%
  str_replace_all("\\.", ",")

employment_type <- job_xml %>% 
  html_elements("div[class *= 'Container'] > div") %>% 
  tail("1") %>% 
  html_text2()

posted_ago_raw <- job_xml %>% 
  html_element("table[class *= 'jobCardShelfContainer']") %>%
  html_element("span[class *= 'date']") %>%
  html_text2() %>% 
  str_after_first("Active |Posted ")

"13 dadad" %>% str_extract("\\d+")

str_extract(posted_ago_raw, "\\d+")

if(str_detect(posted_ago_raw, "30+")){
  job_list_date <- Sys.Date() %>% 
    format("%Y-%m") %>%
    ym() - months(1) 
} else{
  days_ago <- str_extract(posted_ago_raw, "\\d+") %>%
    as.numeric()
  
  job_list_date <- Sys.Date() %>% 
    ymd() - days(days_ago) 
}



### GET THE DETAILS

url <- all_jobs_info[1, ]$job_url
rD$navigate(url)

page <- rD$getPageSource()[[1]] %>% 
  read_html()

description_raw <- page %>% 
  html_element("div[id='jobDescriptionText']")

job_description <- tryCatch({description_raw %>%
    as.character()  %>%
    str_remove_all("\n|\t") %>% 
    str_replace_all('[\"]',  "'") %>%
    str_squish() %>%
    str_replace_all("<p><br></p>", "\n\n") %>%
    str_replace_all("</ul>", "\n\n") %>%
    str_replace_all("<h4.*?>", "<strong>") %>%
    str_replace_all("</h4>", "</strong>") %>%
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

# if(nchar(job_description) > 500){
#   job_description <- substr(job_description, 1, 2000) %>%
#     str_trim("right") %>% 
#     str_remove("<[^>]*$") %>%
#     str_trim("right") %>% 
#     str_remove("<[^>]+>$") %>%
#     str_remove_all("<[^/][^>]*>[^<]*$") %>%
#     str_remove_all("<[^/][^>]*>[^<]*$")
# }
# 
# bot_token <- "6224206664:AAGngscLsRooxT4bUFyx4VjAuSKlL2_3fFI"
# chat_id <- 1415309056
# 
# bot <- Bot(token = bot_token)
# bot$sendMessage(chat_id = 1415309056, text = job_description, parse_mode = "html")


job_list_date <- tryCatch({page %>% 
    html_elements("script") %>%
    .[4] %>%
    html_text2() %>%
    fromJSON() %>%
    .["datePosted"] %>%
    unlist() %>%
    unname() %>%
    as.Date()}, 
    error = function(e) NA)

if(is_empty(job_list_date)) job_list_date <- df$job_list_date


company_link <- page %>% 
  html_element("div[data-company-name *= 'true'] > a") %>%
  html_attr("href")

rD$navigate(company_link)

page <- rD$getPageSource()[[1]] %>% 
  read_html()

industries <- tryCatch({page %>% 
  html_element("li[data-testid *= 'industry']") %>%
  html_elements("div") %>%
  tail(1) %>% 
  html_text2()}, 
  error = function(e) "Not Available")

if(is_empty(industries)) industries <- "Not Available"


job_info_df <- all_jobs_info[1, ]



all_job_details <- all_jobs_info %>%
  group_nest(row_number()) %>% 
  pull(data) %>% 
  map_dfr(enrich_indeed, rD)

## TEST SEND MESSAGE
bot_token <- "6224206664:AAGngscLsRooxT4bUFyx4VjAuSKlL2_3fFI"
chat_id <- 1415309056

tezz <- send_message(all_job_details[sample(nrow(all_job_details), 1), ], bot_token)



df <- all_job_details %>% filter(job_url == "https://id.indeed.com/viewjob?jk=5bec8bf8c9588363")
df <- all_job_details %>% filter(job_url == "https://id.indeed.com/viewjob?jk=a63bf327be909779")

df <- all_job_details %>% filter(job_url == "https://id.indeed.com/viewjob?jk=1bacf61a6f88ea1c")
df <- all_job_details %>% filter(job_url == "https://id.indeed.com/viewjob?jk=aaae90c47d06011d")

tezz <- send_message(df, bot_token)

bot <- Bot(token = bot_token)
bot$sendMessage(chat_id = 1415309056, text = description, parse_mode = "html")



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
      str_replace_all("<h4.*?>|<h3.*?>", "<strong>") %>%
      str_replace_all("</h4>|</h3>", "</strong>") %>%
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
  
  job_list_date <- tryCatch({page %>% 
      html_elements("script") %>%
      .[4] %>%
      html_text2() %>%
      fromJSON() %>%
      .["datePosted"] %>%
      unlist() %>%
      unname() %>%
      as.Date()}, 
      error = function(e) NA)
  
  if(is_empty(job_list_date)) job_list_date <- df$job_list_date
  
  if(is_empty(job_info_df$industries)){
    company_link <- page %>% 
      html_element("div[data-company-name *= 'true'] > a") %>%
      html_attr("href")
    
    rD$navigate(company_link)
    Sys.sleep(3)
    
    page <- rD$getPageSource()[[1]] %>% 
      read_html()
    
    industries <- tryCatch({page %>% 
        html_element("li[data-testid *= 'industry']") %>%
        html_elements("div") %>%
        tail(1) %>% 
        html_text2()}, 
        error = function(e) "Not Available")
    
    if(is_empty(industries)) industries <- "Not Available"
    
    new_company_industry <- cbind(job_info_df$job_company, industries)
    
    glue("Writing new company industry for {job_info_df$job_company} - {industries}")
    
    write.table(new_company_industry,
                file = "./data/company_industry_indeed.csv", 
                sep = ",",
                append = T,
                row.names = F,
                col.names = F)
  } else{
    industries <- job_info_df$industries
  }
 
  job_info_df <- job_info_df %>% mutate(job_list_date = job_list_date)
  
  result_df <- cbind(job_info_df, seniority_level, industries, job_description, applicant, get_time) %>%
    relocate(employment_type, .after = seniority_level)
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


  


"EmployerActive 1 day ago"
"PostedPosted 1 day ago"
"PostedPosted 30+ days ago"




indeed <- function(key, limit = 30L) {
  
  if (missing(key)) {
    key <- "data analyst"
    message(sprintf('Argument "key" is missing, using default: "%s"', key))
  }
  # country and subdomain
  country <- "id"
  
  # query handle
  query <- str_replace_all(key, "\\s+", "+")
  
  # page handle
  page <- ceiling(limit/15)
  page <- (c(1:page)-1)*10
  
  message(sprintf("Pulling job data from Indeed %s...", toupper(country)))
  for (p in page) {
    
    # get html page
    url <- sprintf("https://%s.indeed.com/jobs?q=%s&sort=date&start=%s",
                   country, query, p)
    url <- url(url, "rb")
    htmlraw <- tryCatch(read_html(url))
    close(url)
    
    # get vacancy items
    item <- htmlraw |>
      html_elements(".mosaic-provider-jobcards") |>
      html_children()
    
    # job url for full page direction and the id
    # jobsearch-ResultsList
    job_url <- item[grepl('a id="job', item)] |>
      html_elements(".jobTitle") |>
      html_element("a") |>
      html_attr("href")
    for (item in seq_along(job_url)) {
      # if (str_detect(job_url[item], "\\/rc\\/clk\\?jk")) {
      if (grepl("/rc/clk\\?jk", job_url[item])) {
        job_url[item] <- str_extract(job_url[item], "\\?jk=[a-z0-9]{16}")
      } else {
        job_url[item] <- str_replace(job_url[item], "^(.+)\\?fccid.+$", "\\1")
      }
    }
    job_id <- str_extract(job_url, "[a-z0-9]{16}")
    for (item in seq_along(job_url)) {
      if (grepl("company/.+/jobs", job_url[item])) {
        job_url[item] <- paste0("https://", country, ".indeed.com", job_url[item])
      } else {
        job_url[item] <- paste0("https://", country, ".indeed.com/lihat-lowongan-kerja", job_url[item])
      }
    }
    
    # job title
    job_position <- htmlraw |>
      html_elements(".jobTitle") |>
      html_text() |>
      str_remove("^Baru")
    
    # company
    company_name <- htmlraw |>
      html_elements(".companyName") |>
      html_text()
    
    company_rating <- htmlraw |>
      html_elements(".heading6.company_location") |>
      html_element(".ratingsDisplay") |>
      html_text() |>
      str_replace(",", ".") |>
      as.numeric()
    
    # location
    location <- htmlraw |>
      html_elements(".companyLocation") |>
      html_text()
    company_location <- str_replace(location, "^(.+)\\s?\u2022\\s?.+", "\\1")
    working_location <- str_extract(location, "^.+\\s?\u2022\\s?(.+)") |> str_remove("^.+\\s?\u2022\\s?")
    
    # salary
    salary <- htmlraw |>
      html_elements(".resultContent") |>
      html_element(".salary-snippet") |>
      html_text()
    
    salary_from <- salary |>
      str_replace("^Rp\\.?\\s?(\\d+(\\.?\\d{1,3}){1,3})\\s?-.+", "\\1") |>
      str_remove_all("\\.") |>
      as.numeric()
    
    salary_until <- salary |>
      str_replace("^Rp.+-\\s?Rp\\.?\\s?(\\d+(\\.?\\d{1,3}){1,3})\\s?.+", "\\1") |>
      str_remove_all("\\.") |>
      as.numeric()
    
    # generate dataframe
    joblist <- data.frame(
      id = job_id,
      job_title = job_position,
      job_url = job_url,
      company_name = company_name,
      company_location = company_location,
      company_rating = company_rating,
      working_location = working_location,
      salary_from = salary_from,
      salary_until = salary_until
    ) |> as_tibble()
    
    if (p == 0) { vacancy <- joblist } else {
      vacancy <- bind_rows(vacancy, joblist)
    }
  }
  
  message("Building a data.frame...")
  vacancy <- distinct(vacancy)[1:limit,]
  
  message("Done")
  return(vacancy)
  
}
