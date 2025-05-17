#'
#' Plot total admissions over time
#' 

plot_admissions_time <- function(df,
                                 service = c("sc", "otp", "tsfp_u5", "tsfp_plw"), 
                                 time_unit = c("month", "year")) {
  service <- match.arg(service)
  time_unit <- match.arg(time_unit)

  serv_expr <- dplyr::case_when(
    service == "sc" ~ "service == 'Stabilisation Centre' & type == 'Children under-five years'",
    service == "otp" ~ "service == 'Outpatient Therapeutic Care Programme' & type == 'Children under-five years'",
    service == "tsfp_u5" ~ "service == 'Targeted Supplementary Feeding Programme' & type == 'Children under-five years'",
    service == "tsfp_plw" ~ "service == 'Targeted Supplementary Feeding Programme' & type == 'Pregnant or lactating women'"
  )

  df <- df |>
    dplyr::filter(eval(parse(text = serv_expr))) |>
    dplyr::mutate(
      month_abb = lapply(
        X = month, FUN = function(x) month.abb[month.name == x]
      ) |>
        unlist() |>
        factor(levels = month.abb)
    )

  if (time_unit == "month") {
    title_text <- dplyr::case_when(
      service == "sc" ~ "Monthly Admissions for Stabilisation Centre",
      service == "otp" ~ "Monthly Admissions for Outpatient Therapeutic Care Programme",
      service == "tsfp_u5" ~ "Monthly Admissions for Targeted Supplementary Feeding Programme for Children Under-Five Years",
      service == "tsfp_plw" ~ "Monthly Admissions for Targeted Supplementary Feeding Programme for Pregnant or Lactating Women"
    )

    df |>
      ggplot2::ggplot(
        mapping = ggplot2::aes(
          x = month_abb, y = total, group = year, colour = year
        )
      ) +
      ggplot2::geom_line(linewidth = 1) +
      ggplot2::labs(
        title = title_text,
        subtitle = paste0(min(df$year), " to ", max(df$year)),
        x = "Month", y = "Admissions"
      ) +
      facet_wrap(. ~ district, nrow = 4) +
      oxthema::theme_oxford(
        grid = "XY", grid_col = oxthema::get_oxford_colour("stone")
      ) +
      ggplot2::theme(legend.position = "top")
  } else {
    title_text <- dplyr::case_when(
      service == "sc" ~ "Yearly Admissions for Stabilisation Centre",
      service == "otp" ~ "Yearly Admissions for Outpatient Therapeutic Care Programme",
      service == "tsfp_u5" ~ "Yearly Admissions for Targeted Supplementary Feeding Programme for Children Under-Five Years",
      service == "tsfp_plw" ~ "Yearly Admissions for Targeted Supplementary Feeding Programme for Pregnant or Lactating Women"
    )

    df |>
      dplyr::summarise(total = sum(total), .by = c(year, district)) |>
      ggplot2::ggplot(
        mapping = ggplot2::aes(
          x = year, y = total, group = district, colour = district
        )
      ) +
      ggplot2::geom_line() +
      ggplot2::labs(
        title = title_text,
        subtitle = paste0(min(df$year), " to ", max(df$year)),
        x = "Year", y = "Admissions"
      ) +
      oxthema::theme_oxford(
        grid = "XY", grid_col = oxthema::get_oxford_colour("stone")
      ) +
      ggplot2::theme(legend.position = "top")
  }
}
