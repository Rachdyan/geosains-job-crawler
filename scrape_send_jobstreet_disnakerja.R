library(jsonlite)
library(lubridate)
library(dplyr)
library(rvest)
library(glue)
library(purrr)
library(genTS)
library(stringr)
library(strex)
library(readr)
library(httr)
library(telegram.bot)
library(janitor)
library(tidyr)
library(furrr)
source("./function/send_message.R")
source("./function/jobstreet.R")
source("./function/disnakerja.R")

plan(multisession)

bot_token <- Sys.getenv("BOT_TOKEN")
chat_id <-  -1001748601116
# chat_id <- 1415309056

message("Getting Jobs From Jobstreet")

keywords <- c("geologi", "geology", "mining", "mine", "tambang",
              "surveyor", "gis", "migas", "oil and gas", "foreman",
              "safety", "hse", "superintendent")

scrape_send_jobstreet(keywords, bot_token, chat_id, future = T)


message("Getting Jobs From Disnakerja")

disnakerja_urls <- c("https://www.disnakerja.com/industri/mining/",
                     "https://www.disnakerja.com/industri/migas/")

future_map(disnakerja_urls, scrape_send_disnakerja, bot_token, chat_id)
