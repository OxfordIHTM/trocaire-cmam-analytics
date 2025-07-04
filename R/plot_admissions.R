#'
#' Plot total admissions over time
#' 

plot_admissions <- function(df,
                            service = c("sc", "otp", "tsfp_u5", "tsfp_plw"), 
                            time_unit = c("month", "year")) {
  service <- match.arg(service)
  time_unit <- match.arg(time_unit)

  serv_expr <- get_service_expression(service = service)
  title_text <- create_title_text(service = service, time_unit = time_unit)

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
    df |>
      ggplot2::ggplot(
        mapping = ggplot2::aes(
          x = month_abb, y = total, group = year, colour = year
        )
      ) +
      ggplot2::geom_line(linewidth = 1) +
      ggplot2::scale_colour_manual(
        name = NULL, 
        values = oxthema::get_oxford_colours("plum|sage|orange|royal")
      ) +
      ggplot2::labs(
        title = title_text,
        subtitle = paste0(min(df$year), " to ", max(df$year)),
        x = "Month", y = "Admissions"
      ) +
      ggplot2::facet_wrap(. ~ district, nrow = 4) +
      oxthema::theme_oxford(
        grid = "XY", grid_col = oxthema::get_oxford_colour("stone")
      ) +
      ggplot2::theme(legend.position = "top")
  } else {
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
