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

bot_token <- "6224206664:AAGngscLsRooxT4bUFyx4VjAuSKlL2_3fFI"
chat_id <- 1415309056

map(urls, scrape_send_linkedin, bot_token, chat_id, remote = T)
