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

jobstreet_keyword <- c("geologi", "geology", "mining", "mine", "tambang",
                       "surveyor", "gis", "migas", "oil and gas", "foreman",
                       "safety", "hse", "superintendent")

jobstreet_raw <- map_dfr(jobstreet_keyword, jobstreet)

jobstreet_filtered <- jobstreet_raw %>% 
  filter(!str_detect(company, "Asuransi") & !str_detect(category, "Perbankan")) %>%
  distinct(job_title, company, job_id, .keep_all = T)


jobstreet_enriched <- jobstreet_filtered %>% group_nest(row_number()) %>% 
  pull(data) %>% map_dfr(enrich_jobstreet)

jobstreet_enriched <- jobstreet_enriched %>% mutate(get_time = Sys.time())

jobstreet_tidy <- jobstreet_enriched %>% 
  mutate(job_salary = ifelse(!is.na(salary_currency), glue("{salary_currency}{salary_min %>% as.numeric() %>% formatC(format='d', big.mark=',')} - {salary_currency}{salary_max %>% as.numeric() %>% formatC(format='d', big.mark=',')}"), NA)) %>%
  mutate(city = glue("{city}, {country}")) %>%
  rename(job_company = company, job_location = city, industries = category, job_list_date = posted_at) %>%
  mutate(applicant = NA) %>%
  select(source, job_id, job_url, job_title, job_company, job_location, job_salary, job_list_date, seniority_level, 
         employment_type, industries, job_description, applicant, get_time)


job_scraped_new <- rbind(job_scraped, jobstreet_tidy)




bot_token <- "6224206664:AAGngscLsRooxT4bUFyx4VjAuSKlL2_3fFI"
chat_id <- 1415309056

tezz <- send_message(jobstreet_tidy[sample(nrow(jobstreet_tidy), 1), ], bot_token)

tezz <- send_message(job_scraped[sample(nrow(job_scraped), 1), ], bot_token)

bot <- Bot(token = bot_token)
bot$sendMessage(chat_id = 1415309056, text = description, parse_mode = "html")



tezz <- jobstreet_filtered %>% filter(job_id == "4379000") %>% enrich_jobstreet()

df <-  jobstreet_filtered %>% filter(job_id == "4379000") 
df <-  jobstreet_filtered %>% filter(job_id == "4379007") 
df <-  jobstreet_filtered %>% filter(job_id == "4380139") 
df <-  jobstreet_filtered %>% filter(job_id == "4378228")
df <-  jobstreet_filtered %>% filter(job_id == "4380139")
df <-  jobstreet_filtered %>% filter(job_id == "4380139")

tezz <- df %>% enrich_jobstreet()






url <- mining_job[sample(nrow(mining_job), 1),]$job_url
page <- read_html(url)

desc_info_raw <- page %>% html_element("div[id *= 'contentContainer'] > div > div > div:nth-child(2) > div > div > div")

description_raw <- desc_info_raw %>% html_children() %>% head(-1)

description <- description_raw %>%
  as.character()  %>%
  str_remove_all("\n|\t") %>% 
  str_replace_all('[\"]',  "'") %>%
  str_remove_all("<div class='show-more-less-html__markup show-more-less-html__markup--clamp-after-5          relative overflow-hidden'>|<div class='show-more-less-html__markup relative overflow-hidden'>") %>%
  str_squish() %>%
  str_replace_all("<p><br></p>", "\n\n") %>%
  str_replace_all("</ul>", "\n\n") %>%
  str_replace_all("<h4.*?>", "<strong>") %>%
  str_replace_all("</h4>", "</strong>") %>%
  str_remove_all("<div.*?>|<div>|</div>|<ul.*?>|<ul>|</li>|</p>|</ol>|</br>|<span.*?>|<span>|</span>") %>%
  str_replace_all("<p>|<ol>|<br>", "\n\n") %>%
  str_replace_all("<li>|<li.*?>", "\n • ") %>%
  str_remove_all("•  \n|• \n") %>%
  str_replace_all("  •", " •") %>%
  str_replace_all("(\n{2})\n+", "\n\n")  %>%
  str_replace_all("\n\n</strong>\n", "\n</strong>\n")

if(length(description) > 1){
  description <- str_flatten(description)
}



additional_info_raw <- desc_info_raw %>% 
  html_children() %>%
  tail(1) %>%
  html_element("div") %>% 
  html_children() %>% 
  tail(1) %>%
  html_elements("span")

additional_info_raw2 <- additional_info_raw %>% html_text2()

seniority_level <- additional_info_raw2[which(additional_info_raw2 == "Pengalaman Kerja") + 1]




