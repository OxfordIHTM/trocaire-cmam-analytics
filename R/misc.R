#'
#' Get service expression
#' 

get_service_expression <- function(service = c("sc", "otp", 
                                               "tsfp_u5", "tsfp_plw")) {
  serv_expr <- dplyr::case_when(
    service == "sc" ~ "service == 'Stabilisation Centre' & type == 'Children under-five years'",
    service == "otp" ~ "service == 'Outpatient Therapeutic Care Programme' & type == 'Children under-five years'",
    service == "tsfp_u5" ~ "service == 'Targeted Supplementary Feeding Programme' & type == 'Children under-five years'",
    service == "tsfp_plw" ~ "service == 'Targeted Supplementary Feeding Programme' & type == 'Pregnant or lactating women'"
  )

  ## Return serv_expr ----
  serv_expr
}


#'
#' Create title text
#' 

create_title_text <- function(service = c("sc", "otp", "tsfp_u5", "tsfp_plw"),
                              time_unit = c("month", "year"),
                              by_sex = FALSE) {
  if (time_unit == "month") {
    title_text <- "Monthly Admissions"
  } else {
    title_text <- "Yearly Admissions"
  }

  ## if by_sex ----
  if (by_sex) {
    if (service != "tsfp_plw") {
      title_text <- paste0(title_text, " by Sex")
    }
  }

  ## Return title_text ----
  title_text
}

#'
#' Create sub-title text
#' 

create_subtitle_text <- function(service = c("sc", "otp", 
                                             "tsfp_u5", "tsfp_plw")) {
  dplyr::case_when(
    service == "sc" ~ "Stabilisation Centre",
    service == "otp" ~ "Outpatient Therapeutic Care Programme",
    service == "tsfp_u5" ~ "Targeted Supplementary Feeding Programme for Children under Five Years",
    service == "tsfp_plw" ~ "Targeted Supplementary Feeding Programme for Pregnant or Lactating Women"
  )
}