library(tidyverse)
library(gt)

echo_table <- function(df, table_title, table_subtitle) {
  df |>
    gt() |>
    tab_header(
      title = table_title,
      subtitle = table_subtitle
    ) |>
    tab_style(
      style = list(
        cell_text(
          color = "gray40"
        )
      ),
      locations = cells_column_labels()
    ) |>
    opt_all_caps(
      locations = "column_labels"
    ) |>
    tab_style(
      style = cell_borders(
        sides = "bottom",
        color = "#d3d3d3",
        weight = px(1)
      ),
      locations = cells_body()
    ) |>
    cols_align(
      align = "left",
      columns = where(~ is.character(.x) | is.factor(.x))
    ) |>
    tab_options(
      table.font.names = "Geist",
      table.font.size = px(14),
      heading.align = "left",
      column_labels.padding = px(10),
      data_row.padding = px(8)
    )
}

# echo_table(
#   client_counts,
#   table_title = "My title",
#   table_subtitle = "My subtitle"
# )
