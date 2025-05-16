# General Targets Workflow -----------------------------------------------------


## Load libraries and custom functions ----
suppressPackageStartupMessages(source("packages.R"))
for (f in list.files(here::here("R"), full.names = TRUE)) source (f)


## Data targets
data_targets <- tar_plan(
  tar_target(
    name = onedrive_trocaire,
    command = Microsoft365R::get_business_onedrive(),
    cue = tar_cue("always")
  ),
  tar_target(
    name = trocaire_data_files_list,
    command = onedrive_list_trocaire_files(
      od = onedrive_trocaire, path = "trocaire_somalia_cmam"
    ),
    cue = tar_cue("always")
  ),
  trocaire_data_file_names = file.path(
    "trocaire_somalia_cmam", trocaire_data_files_list$name
  ),
  tar_target(
    name = trocaire_data_files,
    command = onedrive_download_data(
      od = onedrive_trocaire, file_name = trocaire_data_file_names, 
      dest_dir = "data-raw"
    ),
    pattern = trocaire_data_file_names,
    format = "file"
  ),
  tar_target(
    name = trocaire_cmam_data_raw,
    command = cmam_read_data(trocaire_data_files),
    pattern = trocaire_data_files
  ),
  tar_target(
    name = trocaire_cmam_data,
    command = cmam_process_data(trocaire_cmam_data_raw)
  )
)


## Processing targets
processing_targets <- tar_plan(
  
)


## Analysis targets
analysis_targets <- tar_plan(
  
)


## Output targets
output_targets <- tar_plan(
  
)


## Reporting targets
report_targets <- tar_plan(
  
)


## Deploy targets
deploy_targets <- tar_plan(
  
)


## List targets
all_targets()
