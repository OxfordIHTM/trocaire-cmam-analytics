#'
#' Plot total admissions by sex
#' 

plot_admissions_sex <- function(df,
                                service = c("sc", "otp", "tsfp_u5", "tsfp_plw"), 
                                time_unit = c("month", "year")) {
  service <- match.arg(service)
  time_unit <- match.arg(time_unit)

  serv_expr <- get_service_expression(service = service)
  title_text <- create_title_text(
    service = service, time_unit = time_unit, by_sex = TRUE
  )
  subtitle_text <- paste(
    create_subtitle_text(service = service),
    paste0(min(df$year), " to ", max(df$year)),
    sep = " - "
  )

  df <- df |>
    dplyr::filter(eval(parse(text = serv_expr))) |>
    dplyr::mutate(
      month_abb = lapply(
        X = month, FUN = function(x) month.abb[month.name == x]
      ) |>
        unlist() |>
        factor(levels = month.abb)
    ) |>
    dplyr::select(-total, -progress) |>
    tidyr::pivot_longer(male:female, names_to = "sex", values_to = "n") |>
    dplyr::mutate(sex = factor(x = sex, levels = c("male", "female")))

  if (time_unit == "month") {
    df |>
      ggplot2::ggplot(
        mapping = ggplot2::aes(x = month_abb, y = n, fill = sex)
      ) +
      ggplot2::geom_bar(stat = "identity", colour = NA) +
      ggplot2::scale_fill_manual(
        name = NULL,
        values = c(
          oxthema::get_oxford_colour("ocean"), 
          oxthema::get_oxford_colour("ochre")
        )
      ) +
      ggplot2::labs(
        title = title_text, subtitle = subtitle_text,
        x = "Month", y = "Admissions"
      ) +
      ggplot2::facet_grid(
        rows = ggplot2::vars(year), cols = ggplot2::vars(district)
      ) +
      oxthema::theme_oxford(
        grid = "XY", grid_col = oxthema::get_oxford_colour("stone")
      ) +
      ggplot2::theme(
        legend.position = ifelse(service == "tsfp_plw", "none", "top"), 
        axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust = 1)
      )
  } else {
    df |>
      dplyr::summarise(n = sum(n, na.rm = TRUE), .by = c(year, district, sex)) |>
      ggplot2::ggplot(mapping = ggplot2::aes(x = year, y = n, fill = sex)) +
      ggplot2::geom_bar(stat = "identity", colour = NA) +
      ggplot2::scale_fill_manual(
        name = NULL,
        values = c(
          oxthema::get_oxford_colour("ocean"), 
          oxthema::get_oxford_colour("ochre")
        )
      ) +
      ggplot2::labs(
        title = title_text, subtitle = subtitle_text,
        x = "Year", y = "Admissions"
      ) +
      oxthema::theme_oxford(
        grid = "XY", grid_col = oxthema::get_oxford_colour("stone")
      ) +
      ggplot2::theme(
        legend.position = ifelse(service == "tsfp_plw", "none", "top")
      )
  }
}
