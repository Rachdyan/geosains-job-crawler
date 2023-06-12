
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
library(rmarkdown)
library(telegram.bot)

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

quiet <- function(x) { 
  sink(tempfile()) 
  on.exit(sink()) 
  invisible(force(x)) 
} 

driver <- quiet(suppressMessages(
  rsDriver(browser="chrome", port=netstat::free_port(), chromever = NULL, extraCapabilities = extraCap))
)
rD <- driver[["client"]]

rD$close()

url <- "https://www.linkedin.com/jobs/search/?currentJobId=3605575878&f_I=56%2C57&geoId=102478259&keywords=operator&location=Indonesia&refresh=true&sortBy=R"
url <- "https://www.linkedin.com/jobs/search/?currentJobId=3605575878&f_I=56%2C57&geoId=102478259&keywords=engineer&location=Indonesia&refresh=true&sortBy=R"
url <- "https://www.linkedin.com/jobs/search/?currentJobId=3605575878&f_I=56%2C57&geoId=102478259&keywords=surveyor&location=Indonesia&refresh=true&sortBy=R"
url <- "https://www.linkedin.com/jobs/search/?currentJobId=3605575878&f_I=56%2C57&geoId=102478259&keywords=safety&location=Indonesia&refresh=true&sortBy=R"
url <- "https://www.linkedin.com/jobs/search?keywords=geologist&location=Indonesia&geoId=102478259&trk=public_jobs_jobs-search-bar_search-submit&position=1&pageNum=0"
url <- "https://www.linkedin.com/jobs/search?keywords=%22gis%22&location=Indonesia&geoId=102478259&trk=public_jobs_jobs-search-bar_search-submit&position=1&pageNum=0"
url <- "https://www.linkedin.com/jobs/search?keywords=mine&location=Indonesia&geoId=102478259&trk=public_jobs_jobs-search-bar_search-submit&position=1&pageNum=0"


rD$navigate(url)
Sys.sleep(3)


##Scoll Down
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

### GET PAGE
page <- rD$getPageSource()[[1]] %>% 
  read_html()

all_jobs_page <- page %>% html_elements("ul[class *= 'results-list'] > li")
all_jobs_info <- map_dfr(all_jobs_page, get_linkedin)

### CHECK DUPLICATE

job_scraped <- read_csv("./data/job_scraped.csv", col_types = "ccccccc")

new_jobs <- all_jobs_info %>% 
  anti_join(job_scraped, by = join_by("job_id", "job_title", "job_company"))

if(nrow(new_jobs) == 0){
  glue("No new jobs from {url}") %>% message()
} else{
  new_jobs_detail <- new_jobs %>%
    group_nest(row_number()) %>% 
    pull(data) %>%
    map_dfr(enrich_linkedin)
}

write.table(new_jobs_detail,
          file = "./data/job_scraped.csv", 
          sep = ",",
          append = T,
          row.names = F,
          col.names = F)

### SEND MESSAGE
bot_token <- "6224206664:AAGngscLsRooxT4bUFyx4VjAuSKlL2_3fFI"

poosted_df <- new_jobs_detail %>%
  group_nest(row_number()) %>% 
  pull(data) %>%
  map_dfr(send_message, bot_token = bot_token, chat_id = 1415309056)

write.table(poosted_df,
            file = "./data/job_posted.csv", 
            sep = ",",
            append = T,
            row.names = F,
            col.names = T)



scrape_send_linkedin <- function(url){
  driver <- rsDriver(browser="chrome", port=netstat::free_port(), chromever = NULL, extraCapabilities = extraCap)
  rD <- driver[["client"]]
  
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
  
  page <- rD$getPageSource()[[1]] %>% 
    read_html()
  all_jobs_page <- page %>% html_elements("ul[class *= 'results-list'] > li")
  all_jobs_info <- map_dfr(all_jobs_page, get_linkedin)
  
  job_scraped <- read_csv("./data/job_scraped.csv", col_types = "ccccccc")
  
  new_jobs <- all_jobs_info %>% 
    anti_join(job_scraped, by = join_by("job_id", "job_title", "job_company"))
  
  if(nrow(new_jobs) == 0){
    glue("No new jobs from {url}") %>% message()
  } else{
    new_jobs_detail <- new_jobs %>%
      group_nest(row_number()) %>% 
      pull(data) %>%
      map_dfr(enrich_linkedin)
  }
  
  message("Appending new jobs to the existing csv...")
  write.table(new_jobs_detail,
              file = "./data/job_scraped.csv", 
              sep = ",",
              append = T,
              row.names = F,
              col.names = F)
  
  
  poosted_df <- new_jobs_detail %>%
    group_nest(row_number()) %>% 
    pull(data) %>%
    map_dfr(send_message, bot_token = bot_token, chat_id = 1415309056)
  
  write.table(poosted_df,
              file = "./data/job_posted.csv", 
              sep = ",",
              append = T,
              row.names = F,
              col.names = F)
}





job_scraped <- read_csv("./data/job_scraped.csv", col_types = "ccccccc")

df <- job_scraped %>% filter(job_url == "https://www.linkedin.com/jobs/view/3623875605")
df <- job_scraped %>% filter(job_url == "https://www.linkedin.com/jobs/view/3595317650")
df <- job_scraped %>% filter(job_url == "https://www.linkedin.com/jobs/view/3578843667")
df <- job_scraped %>% filter(job_url == "https://www.linkedin.com/jobs/view/3615345098")
df <- job_scraped %>% filter(job_url == "https://www.linkedin.com/jobs/view/3596193123")
df <- job_scraped %>% filter(job_url == "https://www.linkedin.com/jobs/view/3629182360")
df <- job_scraped[sample(nrow(job_scraped), 1), ]

description <- df$job_description

newline_count <- str_count(description, "\n")

if(nchar(description) > 300 && newline_count > 50){
  description <- substr(description, 1, 300) %>% 
    str_trim("right") %>% 
    str_remove("<[^>]*$") %>%
    str_trim("right") %>% 
    str_remove("<[^>]+>$") %>%
    str_remove_all("<[^/][^>]*>[^<]*$") %>%
    str_remove_all("<[^/][^>]*>[^<]*$")
  description <- glue("{description}...\n\nRead more on website:")
} else if(nchar(description) > 500){
  description <- substr(description, 1, 500) %>% 
    str_trim("right") %>% 
    str_remove("<[^>]*$") %>%
    str_trim("right") %>% 
    str_remove("<[^>]+>$") %>%
    str_remove_all("<[^/][^>]*>[^<]*$") %>%
    str_remove_all("<[^/][^>]*>[^<]*$")
  description <- glue("{description}...\n\nRead more on website:")
} 

message <- glue("<strong>{df$job_title %>% str_to_upper()}</strong>\n<em>{df$job_company}</em>\n\nLocation: {df$job_location %>% str_before_first(', Indonesia')}\nLevel: {df$seniority_level} \n\n{description} \n{df$job_url}")
message <- message %>% str_replace_all("(\n{2})\n+", "\n\n") 

bot <- Bot(token = "6224206664:AAGngscLsRooxT4bUFyx4VjAuSKlL2_3fFI")
bot$sendMessage(chat_id = 1415309056, text = message, parse_mode = "html")

rD$close()


send_message <- function(df, bot_token, chat_id){
  bot <- Bot(token = bot_token)
  
  description <- df$job_description
  newline_count <- str_count(description, "\n")
  if(nchar(description) > 300 && newline_count > 60){
    description <- substr(description, 1, 300) %>% str_remove("<.*$")
    description <- glue("{description}...\n\nRead more on website:")
  } else if(nchar(description) > 500){
    description <- substr(description, 1, 500) %>% str_remove("<[^>]*$")
    description <- glue("{description}...\n\nRead more on website:")
  } else{
    description <- glue("{description}\n\n")
  }
  
  message <- glue("<strong>{df$job_title %>% str_to_upper()}</strong>\n<em>{df$job_company}</em>\n\nLocation: {df$job_location %>% str_before_first(', Indonesia')}\nLevel: {df$seniority_level} \n\n{description} \n{df$job_url}")
  message <- message %>% str_replace_all("(\n{2})\n+", "\n\n") 
  
  glue("Sending message for {df$job_title} - {df$job_url}...") %>% message()
  tryCatch({bot$sendMessage(chat_id = 1415309056, text = message, parse_mode = "html")}, 
           error = function(e) glue("Error sending message for {df$job_title} - {df$job_url") %>% 
             print())
  Sys.sleep(2)
  
  df_min <- df %>% select(source, job_url, job_title, job_company)
  log <- cbind(df_min, posted_at = Sys.time())
}













### CARA BARU
page <- rD$getPageSource()[[1]] %>% 
  read_html()


raw_description <- tryCatch({page %>% html_element("div[class *= 'show-more']")},
    error = function(e) NA)

description <- raw_description %>% 
  as.character()  %>%
  str_remove_all("\n|\t") %>% 
  str_replace_all('[\"]',  "'") %>%
  str_remove_all("<div class='show-more-less-html__markup show-more-less-html__markup--clamp-after-5          relative overflow-hidden'>|<div class='show-more-less-html__markup relative overflow-hidden'>") %>%
  str_squish() %>%
  str_replace_all("<p><br></p>", "\n\n") %>%
  str_replace_all("</ul>", "\n\n") %>%
  str_remove_all("<div>|</div>|<ul>|</li>|</p>|</ol>|</br>") %>%
  str_replace_all("<p>|<ol>|<br>", "\n\n") %>%
  str_replace_all("<li>", "\n • ") %>%
  str_remove_all("•  \n|• \n") %>%
  str_replace_all("  •", " •") %>%
  str_replace_all("(\n{2})\n+", "\n\n")  %>%
  str_replace_all("\n\n</strong>\n", "\n</strong>\n")


bot$sendMessage(chat_id = 1415309056, text = description, parse_mode = "html")


if(nchar(description) > 1500){
  description <- substr(description, 1, 1500) %>% str_remove("<.*$")
  description <- glue("{description}...\n\nRead more on website")
}

description