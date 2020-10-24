
get_jobs_url <- function(url_filter = "&jobFields%5B%5D=3085&jobFields%5B%5D=3090&jobFields%5B%5D=4048&jobFields%5B%5D=3084&employmentTypes%5B%5D=3960&employmentTypes%5B%5D=3961&employmentTypes%5B%5D=3963&jobLevels%5B%5D=3954"){
  
  # Build urls
  url_base <- "https://www.karriere.at/jobs/wien-und-umgebung?"
  url_page <- "page="
  
  # Get number of pages
  page_n <- read_html(paste0(url_base, url_page, 1, url_filter)) %>% 
    html_nodes(".m-pagination__meta") %>%
    html_text() %>%
    str_split("von") %>% 
    .[[1]] %>% 
    .[[2]] %>% 
    parse_number()
  
  # Construct filtered urls
  url_pages <- c(1:page_n) %>% map_chr(~paste0(url_base, url_page, ., url_filter))
  
  # Extract jobs per page
  jobs <- url_pages %>% map(function(.x) {
    Sys.sleep(rnorm(1, 4, 1.5))
    read_html(.x)  %>% html_nodes(css = ".m-jobsListItem__titleLink") %>% html_attr("href")
    }) %>% 
    do.call(c, .)

  jobs
  
}
