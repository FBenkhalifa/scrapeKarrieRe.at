# Build urls
jobs <- get_jobs_url()

# Extract job infos
job_infos <- jobs %>% map_dfr(extract_job_infos)

# Write to excel
write_excel_csv2(job_infos, "./jobs.csv")
