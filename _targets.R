# Trocaire CMAM Analytics Workflow ---------------------------------------------


## Load libraries and custom functions ----
suppressPackageStartupMessages(source("packages.R"))
for (f in list.files(here::here("R"), full.names = TRUE)) source (f)


## Data targets
data_targets <- tar_plan(
  tar_target(
    name = trocaire_data_files_list,
    command = gdrive_list_trocaire_files(path = "cmam"),
    cue = tar_cue("always")
  ),
  trocaire_data_file_names = trocaire_data_files_list$name,
  tar_target(
    name = trocaire_data_files,
    command = gdrive_download_data(
      file = trocaire_data_file_names, dest_dir = "data-raw"
    ),
    pattern = trocaire_data_file_names,
    format = "file"
  ),
  tar_target(
    name = trocaire_cmam_data_raw,
    command = cmam_read_data(trocaire_data_files),
    pattern = trocaire_data_files
  )
)


## Processing targets
processing_targets <- tar_plan(
  tar_target(
    name = trocaire_cmam_data,
    command = cmam_process_data(trocaire_cmam_data_raw)
  )
)


## Analysis targets
analysis_targets <- tar_plan(
  tar_target(
    name = sc_admissions_monthly,
    command = plot_admissions(
      df = trocaire_cmam_data, service = "sc", time_unit = "month"
    )
  ),
  tar_target(
    name = sc_admissions_yearly,
    command = plot_admissions(
      df = trocaire_cmam_data, service = "sc", time_unit = "year"
    )
  ),
  tar_target(
    name = otp_admissions_monthly,
    command = plot_admissions(
      df = trocaire_cmam_data, service = "otp", time_unit = "month"
    )
  ),
  tar_target(
    name = otp_admissions_yearly,
    command = plot_admissions(
      df = trocaire_cmam_data, service = "otp", time_unit = "year"
    )
  ),
  tar_target(
    name = tsfp_u5_admissions_monthly,
    command = plot_admissions(
      df = trocaire_cmam_data, service = "tsfp_u5", time_unit = "month"
    )
  ),
  tar_target(
    name = tsfp_u5_admissions_yearly,
    command = plot_admissions(
      df = trocaire_cmam_data, service = "tsfp_u5", time_unit = "year"
    )
  ),
  tar_target(
    name = tsfp_plw_admissions_monthly,
    command = plot_admissions(
      df = trocaire_cmam_data, service = "tsfp_plw", time_unit = "month"
    )
  ),
  tar_target(
    name = tsfp_plw_admissions_yearly,
    command = plot_admissions(
      df = trocaire_cmam_data, service = "tsfp_plw", time_unit = "year"
    )
  ),
  tar_target(
    name = sc_admissions_by_sex_monthly,
    command = plot_admissions_sex(
      df = trocaire_cmam_data, service = "sc", time_unit = "month"
    )
  ),
  tar_target(
    name = sc_admissions_by_sex_yearly,
    command = plot_admissions_sex(
      df = trocaire_cmam_data, service = "sc", time_unit = "year"
    )
  ),
  tar_target(
    name = otp_admissions_by_sex_monthly,
    command = plot_admissions_sex(
      df = trocaire_cmam_data, service = "otp", time_unit = "month"
    )
  ),
  tar_target(
    name = otp_admissions_by_sex_yearly,
    command = plot_admissions_sex(
      df = trocaire_cmam_data, service = "otp", time_unit = "year"
    )
  ),
  tar_target(
    name = tsfp_u5_admissions_by_sex_monthly,
    command = plot_admissions_sex(
      df = trocaire_cmam_data, service = "tsfp_u5", time_unit = "month"
    )
  ),
  tar_target(
    name = tsfp_u5_admissions_by_sex_yearly,
    command = plot_admissions_sex(
      df = trocaire_cmam_data, service = "tsfp_u5", time_unit = "year"
    )
  ),
  tar_target(
    name = tsfp_plw_admissions_by_sex_monthly,
    command = plot_admissions_sex(
      df = trocaire_cmam_data, service = "tsfp_plw", time_unit = "month"
    )
  ),
  tar_target(
    name = tsfp_plw_admissions_by_sex_yearly,
    command = plot_admissions_sex(
      df = trocaire_cmam_data, service = "tsfp_plw", time_unit = "year"
    )
  )
)


## Output targets
output_targets <- tar_plan(
  
)


## Reporting targets
report_targets <- tar_plan(
  tar_quarto(
    name = data_review_report,
    path = "reports/cmam-data-review.qmd",
    working_directory = here::here(),
    quiet = FALSE,
    cue = tar_cue("always")
  )
)


## Deploy targets
deploy_targets <- tar_plan(
  
)


## List targets
all_targets()
