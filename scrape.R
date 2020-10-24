library(glue)
# Build urls
jobs <- get_jobs_url()

# Extract job infos
job_infos <- jobs %>% map_dfr(extract_job_infos)
job_infos <- job_infos %>% rowid_to_column("id")
# save(job_infos, file = "./data/job_infos.rda")

# Write to excel
write_excel_csv2(job_infos, "./jobs.csv")


# Find the application documents
files <- list.files("./application_docs/", full.names = TRUE)

# Write to directory
for (job_n in c(1:nrow(job_infos[1:4, ]))){
  
  # Get job
  job <- job_infos %>% slice(job_n)
  
  # Create directory
  dir_name <- glue("./applications/{job$id}-{job$company}")
  dir.create(dir_name)
  
  # copy the files to the new folder
  file.copy(files, dir_name)

  

    rmarkdown::render(
      'motivation_letter.Rmd',
      output_format= "word_document",
      output_file = paste0(dir_name, '/motivation_letter.doc'),
      params = list(company = job$company, job = job$job_title)
    )
}
