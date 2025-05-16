#'
#' Read and process data
#' 

cmam_read_data <- function(file_path) {
  df <- openxlsx::read.xlsx(xlsxFile = file_path, startRow = 2, cols = 1:17)

  ## get year ----
  .year <- names(df)[1] |>
    stringr::str_extract(pattern= "[0-9]{4}")

  .year <- ifelse(is.na(.year), "2021", .year)

  ## Process data ----
  df <- df |>
    stats::setNames(
      nm = c(
        "month", "district", 
        "sc_u5_male", "sc_u5_female", "sc_u5_total", "sc_u5_progress",
        "otp_u5_male", "otp_u5_female", "otp_u5_total", "otp_u5_progress",
        "sfp_u5_male", "sfp_u5_female", "sfp_u5_total", "sfp_u5_progress",
        "sfp_plw_female", "sfp_plw_total", "sfp_plw_progress"
      )
    ) |>
    dplyr::slice(-1) |>
    dplyr::filter(
      stringr::str_detect(string = district, pattern = "Total", negate = TRUE)
    ) |>
    tidyr::fill(month) |>
    dplyr::mutate(
      month = stringr::str_to_title(month),
      dplyr::across(
        sc_u5_male:sfp_plw_progress, 
        .fns = function(x) as.integer(x) |>
          (\(x) ifelse(is.na(x), 0, x))()
      ),
      year = .year
    ) |>
    dplyr::relocate(year, .before = month) |>
    tibble::as_tibble()

  ## Return df ----
  df
}


#'
#' Read and process data
#'
#' 
cmam_process_data <- function(cmam_raw_data) {
  ## Long format ----
  df <- cmam_raw_data |>
    tidyr::pivot_longer(
      cols = sc_u5_male:sfp_plw_progress,
      names_to = c("service", "type", ".value"),
      names_sep = "_",
      values_to = "n"
    ) |>
    dplyr::mutate(
      month = lapply(X = month, FUN = function(x) month.name[month.abb == x]) |> 
        unlist() |>
        factor(levels = month.name),
      service = dplyr::case_when(
        service == "sc" ~ "Stabilisation Centre",
        service == "otp" ~ "Outpatient Therapeutic Programme",
        service == "sfp" ~ "Targeted Supplementary Feeding Programme",
        .default = service 
      ),
      type = dplyr::case_when(
        type == "u5" ~ "Children under-five years",
        type == "plw" ~ "Pregnant or lactating women",
        .default = type
      )
    ) |>
    dplyr::arrange(year, service, district) |>
    tibble::as_tibble()
 
  ## Return df ----
  df
}
