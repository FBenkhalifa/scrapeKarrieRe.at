library(tidyverse)
library(rvest)
library(lubridate)


# Set static variables ----------------------------------------------------

extract_job_infos <- function(url, wait = 4){

  # Set css classes of job features to extract
  JOB_FEATURES <- c(
    job_title = ".m-jobHeader__jobTitle",
    company = ".m-jobHeader__metaList .m-jobHeader__companyName", 
    job_locations = ".m-jobHeader__metaList .m-jobHeader__jobLocations", 
    job_employment_types = ".m-jobHeader__metaList .m-jobHeader__jobEmploymentTypes",
    job_level = ".m-jobHeader__metaList .m-jobHeader__jobLevel",
    job_date = ".m-jobHeader__metaList .m-jobHeader__jobDate")
  
  
  # Get job html
  job <- read_html(url)
  
  # Extract job infos
  job_infos <- JOB_FEATURES %>% map_dfr(~job %>% html_nodes(css = .x) %>% html_text(.) %>% str_squish(.))
  
  # Add company_link and job_link
  company_link <- job %>% html_nodes(".m-jobHeader__companyLink") %>% html_attr("href")
  job_infos <- job_infos %>% 
    mutate(job_date =dmy(job_date),
           company_link = paste0("https://www.karriere.at", company_link),
           job_link = url)
  
  # Wait system sleep
  Sys.sleep(rnorm(1, wait, 1.5))
  job_infos
}


