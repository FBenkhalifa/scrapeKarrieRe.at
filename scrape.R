library(glue)


# Gather jobs -------------------------------------------------------------

# Build urls
jobs <- get_jobs_url()

# Extract job infos
job_infos <- jobs %>% map_dfr(extract_job_infos) %>% rowid_to_column("id")
# save(job_infos, file = "./data/job_infos.rda")

# Write to excel
write_excel_csv2(job_infos, "./jobs.csv")


# Create directories ------------------------------------------------------


# Find the application documents
files <- list.files("./application_docs/", full.names = TRUE)

# Write to directory
for (job_n in c(1:nrow(job_infos))){
  
  # Get job
  job <- job_infos %>% slice(5)
  
  # Create directory
  file_name <- stringi::stri_replace_all_fixed(
    glue("{job$id}-{job$company}"), 
    c("ä", "ö", "ü", "Ä", "Ö", "Ü"), 
    c("ae", "oe", "ue", "Ae", "Oe", "Ue"), 
    vectorize_all = FALSE
  )
  dir_name <- glue("./applications/{file_name}")
  dir.create(dir_name)
  
  # copy the files to the new folder
  file.copy(files, dir_name)

    rmarkdown::render(
      './rmd/motivation_letter_word.Rmd',
      output_format= "word_document",
      output_file = paste0(".", dir_name, '/motivation_letter.docx'),
      params = list(company = job$company, job = job$job_title)
    )

    rmarkdown::render(
      './rmd/motivationsschreiben_word.Rmd',
      output_format= "word_document",
      output_file = paste0(".", dir_name, '/Anschreiben.docx'),
      params = list(company = job$company, job = job$job_title)
    )
}
