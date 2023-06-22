
send_message <- function(df, bot_token, chat_id){
  bot <- Bot(token = bot_token)
  
  description <- df$job_description
  newline_count <- str_count(description, "\n")
  
  if(is.na(description)){
    description <- ""
  }
  
  if(nchar(description) > 300 && newline_count > 60){
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
  } else{
    description <- glue("{description}\n\n")
  }
  
  if(is.na(df$job_location) && is.na(df$seniority_level)){
    message <- glue("<strong>{df$job_title %>% str_to_upper()}</strong>\n<em>{df$job_company}</em>\n\n{description} \n{df$job_url}")
  } else if(is.na(df$seniority_level) || df$source == "Jobstreet"){
    message <- glue("<strong>{df$job_title %>% str_to_upper()}</strong>\n<em>{df$job_company}</em>\n\nLocation: {df$job_location %>% str_before_first(', Indonesia')}\n\n{description} \n{df$job_url}")
  } else if(is.na(df$job_location)){
    message <- glue("<strong>{df$job_title %>% str_to_upper()}</strong>\n<em>{df$job_company}</em>\n\nLevel: {df$seniority_level} \n\n{description} \n{df$job_url}")
  } else {
    message <- glue("<strong>{df$job_title %>% str_to_upper()}</strong>\n<em>{df$job_company}</em>\n\nLocation: {df$job_location %>% str_before_first(', Indonesia')}\nLevel: {df$seniority_level} \n\n{description} \n{df$job_url}")
  }
  
  message <- message %>% str_replace_all("(\n{2})\n+", "\n\n") 
  
  glue("Sending message for {df$job_title} - {df$job_url}") %>% message()
  tryCatch({bot$sendMessage(chat_id = 1415309056, text = message, parse_mode = "html")}, 
           error = function(e) glue("Error sending message for {df$job_title} - {df$job_url}") %>% 
             print())
  Sys.sleep(sample(3:6, 1))
  
  df_min <- df %>% select(source, job_url, job_title, job_company)
  log <- cbind(df_min, posted_at = Sys.time())
}