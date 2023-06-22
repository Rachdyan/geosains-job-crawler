

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

jobstreet <- function(key, limit = 30L) {
  
  if (missing(key)) {
    key <- "data analyst"
    message(sprintf('Argument "key" is missing, using default: "%s"', key))
  }
  
  page <- seq(1L, ceiling(limit/30L), 1L)
  country <- "id"
  url <- sprintf(
    "https://xapi.supercharge-srp.co/job-search/graphql?country=%s&isSmartSearch=true",
    country
  )
  
  var <- sapply(page, function(p) {
    toJSON(list(keyword = key,
                jobFunctions = list(),
                locations = list(),
                salaryType = 1,
                jobTypes = list(),
                careerLevels = list(),
                page = p,
                country = country,
                categories = list(),
                workTypes = list(),
                industries = list(),
                locale = "id"),
           auto_unbox = TRUE)
  })
  
  query <- 'query getJobs($country: String, $locale: String,
  $keyword: String, $createdAt: String, $jobFunctions: [Int],
  $categories: [String], $locations: [Int], $careerLevels: [Int],
  $minSalary: Int, $maxSalary: Int, $salaryType: Int,
  $candidateSalary: Int, $candidateSalaryCurrency: String,
  $datePosted: Int, $jobTypes: [Int], $workTypes: [String],
  $industries: [Int], $page: Int, $pageSize: Int, $companyId: String,
  $advertiserId: String, $userAgent: String, $accNums: Int,
  $subAccount: Int, $minEdu: Int, $maxEdu: Int, $edus: [Int],
  $minExp: Int, $maxExp: Int, $seo: String, $searchFields: String,
  $candidateId: ID, $isDesktop: Boolean, $isCompanySearch: Boolean,
  $sort: String, $sVi: String, $duplicates: String, $flight: String,
  $solVisitorId: String) {
    jobs(
      country: $country
      locale: $locale
      keyword: $keyword
      createdAt: $createdAt
      jobFunctions: $jobFunctions
      categories: $categories
      locations: $locations
      careerLevels: $careerLevels
      minSalary: $minSalary
      maxSalary: $maxSalary
      salaryType: $salaryType
      candidateSalary: $candidateSalary
      candidateSalaryCurrency: $candidateSalaryCurrency
      datePosted: $datePosted
      jobTypes: $jobTypes
      workTypes: $workTypes
      industries: $industries
      page: $page
      pageSize: $pageSize
      companyId: $companyId
      advertiserId: $advertiserId
      userAgent: $userAgent
      accNums: $accNums
      subAccount: $subAccount
      minEdu: $minEdu
      edus: $edus
      maxEdu: $maxEdu
      minExp: $minExp
      maxExp: $maxExp
      seo: $seo
      searchFields: $searchFields
      candidateId: $candidateId
      isDesktop: $isDesktop
      isCompanySearch: $isCompanySearch
      sort: $sort
      sVi: $sVi
      duplicates: $duplicates
      flight: $flight
      solVisitorId: $solVisitorId
    ) {
      relatedSearchKeywords {
        keywords
      }
      jobs {
        job_id: id
        company: companyMeta {
          id
          name
        }
        job_title: jobTitle
        employment: employmentTypes {
          type: name
        }
        city: locations {
          name
        }
        category: categories {
          id: code
          name
        }
        salary: salaryRange {
          max
          min
          currency
          period
        }
        posted_at: postedAt
      }
    }
  }'
  
  message(sprintf("Pulling job data from Jobstreet (Seek %s)...",
                  toupper(country)))
  
  jobs <- map(var, ~gql(query = query, var = .x, url = url))
  jobs <- map(jobs, ~{.x$jobs$jobs})
  
  message("Building a data.frame...")
  
  vacancy <- map_df(jobs, ~restruct_job(.x))
  vacancy <- distinct(vacancy)[1:limit,]
  
  message("Done")
  return(vacancy)
}


gql <- function(query,
                ...,
                token = NULL,
                var = NULL,
                opnam = NULL,
                url = url){
  pbody <- list(query = query, variables = var, operationName = opnam)
  if (is.null(token)) {
    res <- POST(url, body = pbody, encode = "json", ...)
  } else {
    auth_header <- paste("bearer", token)
    res <- POST(
      url,
      body = pbody,
      encode = "json",
      add_headers(Authorization = auth_header),
      ...
    )
  }
  res <- content(res, as = "parsed", encoding = "UTF-8")
  if (!is.null(res$errors)) {
    warning(toJSON(res$errors))
  }
  return(res$data)
}

restruct_job <- function(jobs){
  
  # restructure
  for (i in seq_along(jobs)) {
    v <- unlist(jobs[[i]])
    v <- cbind(name = names(v), value = v)
    v <- as_tibble(v) %>% mutate(num = i)
    if(i == 1){
      vacancy <- v
    } else {
      vacancy <- bind_rows(vacancy, v)
    }
  }
  
  # reform
  vacancy <- vacancy %>%
    group_by(num, name) %>%
    summarise_all(~toString(value)) %>%
    ungroup() %>%
    pivot_wider(
      id_cols = "num",
      names_from = "name",
      values_from = "value"
    ) %>%
    select(-num) %>%
    clean_names()
  
  # arrange
  if (nchar(vacancy$job_id[1]) == 7) { # jobstreet
    
    vacancy <- vacancy %>%
      mutate(job_url = paste0("https://www.jobstreet.co.id/id/job/", job_id),
             source = "Jobstreet",
             country = "Indonesia",
             is_remote = NA,
             posted_at = ymd(str_replace(posted_at, "^(\\d{4}-\\d{2}-\\d{2}).+$", "\\1"))) %>%
      select(
        "job_title",
        "company" = "company_name",
        "city" = "city_name",
        "country",
        "is_remote",
        "category" = "category_name",
        "salary_currency",
        "salary_min",
        "salary_max",
        "salary_period",
        matches("employ"),
        "posted_at",
        "source",
        "job_url",
        "job_id"
      )
    
  } else {
    
    message("Something wrong")
    
  }
  
  return(vacancy)
  
}


enrich_jobstreet <- function(df){
  url <- df$job_url
  
  glue("Getting Job Details for {df$job_title} - {url}") %>% print()
  
  Sys.sleep(sample(1:3, 1))
  read_page <- GET(url, add_headers('user-agent' = sample(user_agent_list, 1)))  %>%
    safe_read_html()
  
  page <- read_page$result
  
  if(!is.null(page)){
    desc_info_raw <- tryCatch({page %>% 
        html_element("div[id *= 'contentContainer'] > div > div > div:nth-child(2) > div > div > div")}, 
        error = function(e) NA)
    
    description_raw <- tryCatch({desc_info_raw %>% 
        html_children() %>% 
        head(-1)}, 
        error = function(e) NA)
    
    
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
        str_remove_all("•  \n|• \n") %>%
        str_replace_all("  •", " •") %>%
        str_replace_all("(\n{2})\n+", "\n\n")  %>%
        str_replace_all("\n\n</strong>\n", "\n</strong>\n")}, 
        error = function(e) NA)
    
    if(all(sapply(job_description, genTS::is_empty))){
      job_description <- NA
    } 
    
    if(length(job_description) > 1){
      job_description <- str_flatten(job_description)
    }
    
    additional_info_raw <- tryCatch({desc_info_raw %>% 
        html_children() %>%
        tail(1) %>%
        html_element("div") %>% 
        html_children() %>% 
        tail(1) %>%
        html_elements("span") %>%
        html_text2()}, 
        error = function(e) NA)
    
    seniority_level <- tryCatch({additional_info_raw[which(additional_info_raw == "Tingkat Pekerjaan") + 1]}, 
                                error = function(e) NA)
    
    seniority_level <- ifelse(genTS::is_empty(seniority_level), NA, seniority_level)
    
    company_info_raw <- tryCatch({page %>% 
      html_element("div[id *= 'contentContainer'] > div > div > div:nth-child(2) > div > div:nth-child(2) > div > div:nth-child(2)") %>%
      html_elements("span") %>% 
      html_text2()}, 
      error = function(e) NA)
    
    industries <- tryCatch({company_info_raw[which(company_info_raw == "Industri") + 1]}, 
                           error = function(e) NA)
    
    
    get_time <- Sys.time()
    
    result_df <- tryCatch({cbind(df, job_description, seniority_level, industries, get_time)},
                          error = function(e) cbind(df, job_description = NA, seniority_level = NA, industries = NA, get_time))
    
  }  else{
    error_message <- read_page$error %>% as.character()
    
    result_df <- cbind(df, job_description = error_message, seniority_level = error_message, industries = NA, get_time =  Sys.time())
  }
  
}

keywords <- c("geologi", "geology", "mining", "mine", "tambang",
                       "surveyor", "gis", "migas", "oil and gas", "foreman",
                       "safety", "hse", "superintendent")

scrape_send_jobstreet <- function(keywords, bot_token, chat_id){
  jobstreet_raw <- map_dfr(keywords, jobstreet)
  
  jobstreet_filtered <- jobstreet_raw %>% 
    filter(!str_detect(company, "Asuransi") & !str_detect(category, "Perbankan|Manufaktur")) %>%
    distinct(job_title, company, job_id, .keep_all = T)
  
  job_scraped <- read_csv("./data/job_scraped.csv", col_types = "ccccccc")
  
  new_jobs <- jobstreet_filtered %>% 
    anti_join(job_scraped, by = join_by("source","job_id", "job_title"))
  
  if(nrow(new_jobs) == 0){
    glue("No new jobs from {url}") %>% message()
    return(NA)
  } else{
    glue("Total New Jobs: {nrow(new_jobs)}") %>% message()
    new_jobs_detail <-  new_jobs %>% 
      group_nest(row_number()) %>% 
      pull(data) %>%
      map_dfr(enrich_jobstreet)  %>% 
      mutate(job_salary = ifelse(!is.na(salary_currency), glue("{salary_currency}{salary_min %>% as.numeric() %>% formatC(format='d', big.mark=',')} - {salary_currency}{salary_max %>% as.numeric() %>% formatC(format='d', big.mark=',')}"), NA)) %>%
      mutate(city = glue("{city}, {country}")) %>%
      rename(job_company = company, job_location = city, industries, job_list_date = posted_at) %>%
      mutate(applicant = NA) %>%
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
  
  poosted_df <- new_jobs_detail %>%
    group_nest(row_number()) %>% 
    pull(data) %>%
    map_dfr(send_message, bot_token = bot_token, chat_id = chat_id)
  
  message("Appending posted job info to the existing csv..")
  write.table(poosted_df,
              file = "./data/job_posted.csv", 
              sep = ",",
              append = T,
              row.names = F,
              col.names = F)
  
  message("Done!")
  
}