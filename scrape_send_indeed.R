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
source("./function/indeed.R")
source("./function/petromindo.R")

plan(multisession)

bot_token <- Sys.getenv("BOT_TOKEN")
chat_id <-  -1001748601116
# chat_id <- 1415309056


message("Getting Jobs From Indeed")

indeed_urls <- c("https://id.indeed.com/jobs?q=geology&sort=date", 
                 "https://id.indeed.com/jobs?q=geologi&sort=date", 
                 "https://id.indeed.com/jobs?q=geologist&sort=date",
                 "https://id.indeed.com/jobs?q=mine&sort=date",
                 "https://id.indeed.com/jobs?q=mining&sort=date",
                 "https://id.indeed.com/jobs?q=oil+and+gas&sort=date",
                 "https://id.indeed.com/jobs?q=migas&sort=date",
                 "https://id.indeed.com/jobs?q=geodesi&sort=date",
                 "https://id.indeed.com/jobs?q=tambang&sort=date",
                 'https://id.indeed.com/jobs?q="gis"&sort=date')

future_map(indeed_urls, scrape_send_indeed, bot_token, chat_id, remote = T, all_pages = F)
