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
    title_text <- dplyr::case_when(
      service == "sc" ~ "Monthly Admissions for Stabilisation Centre",
      service == "otp" ~ "Monthly Admissions for Outpatient Therapeutic Care Programme",
      service == "tsfp_u5" ~ "Monthly Admissions for Targeted Supplementary Feeding Programme for Children Under-Five Years",
      service == "tsfp_plw" ~ "Monthly Admissions for Targeted Supplementary Feeding Programme for Pregnant or Lactating Women"
    )
  } else {
    title_text <- dplyr::case_when(
      service == "sc" ~ "Yearly Admissions for Stabilisation Centre",
      service == "otp" ~ "Yearly Admissions for Outpatient Therapeutic Care Programme",
      service == "tsfp_u5" ~ "Yearly Admissions for Targeted Supplementary Feeding Programme for Children Under-Five Years",
      service == "tsfp_plw" ~ "Yearly Admissions for Targeted Supplementary Feeding Programme for Pregnant or Lactating Women"
    )
  }

  ## if by_sex ----
  if (by_sex) title_text <- paste0(title_text, " by Sex")
  
  ## Return title_text ----
  title_text
}