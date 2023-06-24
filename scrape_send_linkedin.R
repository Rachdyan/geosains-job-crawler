library(RSelenium)
library(jsonlite)
library(lubridate)
library(dplyr)
library(rvest)
library(glue)
library(purrr)
library(genTS)
library(stringr)
library(netstat)
library(strex)
library(readr)
library(httr)
library(telegram.bot)
library(janitor)
library(tidyr)
library(furrr)
source("./function/send_message.R")
source("./function/jobstreet.R")
source("./function/linkedin.R")


bot_token <- "6224206664:AAGngscLsRooxT4bUFyx4VjAuSKlL2_3fFI"
chat_id <- 1415309056

message("Getting Jobs From Linkedin")

urls <- c(
  "https://www.linkedin.com/jobs/search/?currentJobId=3612329140&f_I=61%2C63%2C56%2C57&geoId=102478259&keywords=operator&location=Indonesia&refresh=true&sortBy=R&position=18&pageNum=0", 
  "https://www.linkedin.com/jobs/search/?currentJobId=3612329140&f_I=61%2C63%2C56%2C57&geoId=102478259&keywords=engineer&location=Indonesia&refresh=true&sortBy=R&position=18&pageNum=0", 
  "https://www.linkedin.com/jobs/search/?currentJobId=3612329140&f_I=61%2C63%2C56%2C57&geoId=102478259&keywords=surveyor&location=Indonesia&refresh=true&sortBy=R&position=18&pageNum=0",
  "https://www.linkedin.com/jobs/search/?currentJobId=3612329140&f_I=61%2C63%2C56%2C57&geoId=102478259&keywords=gis&location=Indonesia&refresh=true&sortBy=R&position=1&pageNum=0",
  "https://www.linkedin.com/jobs/search/?currentJobId=3605575878&f_I=56%2C57&geoId=102478259&keywords=safety&location=Indonesia&refresh=true&sortBy=R",
  "https://www.linkedin.com/jobs/search?keywords=geologist&location=Indonesia&geoId=102478259&trk=public_jobs_jobs-search-bar_search-submit&position=1&pageNum=0",
  "https://www.linkedin.com/jobs/search/?currentJobId=3612329140&f_I=61%2C63%2C56%2C57&geoId=102478259&keywords=mine&location=Indonesia&refresh=true&sortBy=R&position=18&pageNum=0",
  "https://www.linkedin.com/jobs/search/?currentJobId=3612329140&f_I=61%2C63%2C56%2C57&geoId=102478259&keywords=foreman&location=Indonesia&refresh=true&sortBy=R&position=18&pageNum=0",
  "https://www.linkedin.com/jobs/search/?currentJobId=3612329140&f_I=61%2C63%2C56%2C57&geoId=102478259&keywords=supervisor&location=Indonesia&refresh=true&sortBy=R&position=18&pageNum=0",
  "https://www.linkedin.com/jobs/search/?currentJobId=3612329140&f_I=61%2C63%2C56%2C57&geoId=102478259&keywords=manager&location=Indonesia&refresh=true&sortBy=R&position=18&pageNum=0",
  "https://www.linkedin.com/jobs/search/?currentJobId=3612329140&f_I=61%2C63%2C56%2C57&geoId=102478259&keywords=head&location=Indonesia&refresh=true&sortBy=R&position=18&pageNum=0"
)


# map(urls, scrape_send_linkedin, bot_token, chat_id, remote = T)
future_map(urls, scrape_send_linkedin, bot_token, chat_id, remote = T)

message("Getting Jobs From Jobstreet")

keywords <- c("geologi", "geology", "mining", "mine", "tambang",
              "surveyor", "gis", "migas", "oil and gas", "foreman",
              "safety", "hse", "superintendent")

scrape_send_jobstreet(keywords, bot_token, chat_id, future = T)
