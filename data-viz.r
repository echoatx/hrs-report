# Load Packages -----------------------------------------------------------


library(tidyverse)
library(scales)


# Define Colors -----------------------------------------------------------

echo_blue <- "#2373b9"
echo_yellow <- "#f0b405"
echo_green <- "#50dc69"


# Color Palettes ----------------------------------------------------------

scale_fill_echo <- function() {
  scale_fill_manual(
    values = c(echo_blue, echo_yellow, echo_green)
  )
}


scale_color_echo <- function() {
  scale_color_manual(
    values = c(echo_blue, echo_yellow, echo_green)
  )
}


# Define Theme ------------------------------------------------------------

theme_echo <- function(add_y_grid_lines = FALSE) {
  
  theme_echo <-
    theme_void(
    base_family = "Lora",
    base_size = 16
  ) +
    theme(
      axis.text = element_text(),
      axis.title.y = element_text(angle = 90),
      legend.position = "top"
    )
  
  if (add_y_grid_lines == TRUE) {
    theme_echo <-
      theme_echo +
      theme(panel.grid.major.y = element_line(
        color = "gray80"
      ))
  }
  
  theme_echo
}

theme_set(theme_echo())



# Import Data -------------------------------------------------------------

housing_moves <-
  read_csv("data-raw/housing_moves.csv") |>
  mutate(people_formatted = comma(people))


# Plot --------------------------------------------------------------------

housing_moves |>
  ggplot(
    aes(
      x = year,
      y = people,
      fill = program,
      label = people_formatted
    )
  ) +
  geom_col() +
  geom_text(
    position = position_stack(
      vjust = 0.5
    )
  ) +
  scale_y_continuous(
    labels = comma_format()
  ) +
  # scale_fill_manual(
  #   values = c(
  #     "Minimal Housing Assistance" = echo_blue,
  #     "Permanent Supportive Housing" = echo_yellow,
  #     "Rapid Re-Housing" = echo_green
  #   )
  # ) +
  scale_fill_echo() +
  labs(
    y = "People",
    x = NULL,
    fill = NULL
  )

# Plot -----------------Client histogram---------------------------

client_years <-
  read_csv("data-raw/Client_Counts.csv")

# clients_overTime <-
ggplot(
  client_years,
  aes(
    x = factor(Year),
    y = n
  )
) +
  geom_col(fill = "#1c4750", width = .6) +
  geom_text(
    aes(label = comma(n)),
    color = "black",
    family = "Lora",
    vjust = -.3,
    size = 24 / .pt
  ) +
  scale_y_continuous(
    limits = c(0, 30000),
    breaks = seq(0, 30000, by = 10000),
    labels = comma,
    expand = c(0, 0.)
  ) +
  labs(x = NULL, y = "People Served")



# Race Ethnicity Counts ---------------------------------------------------

race_ethnicity_counts <-
  read_csv("data-raw/RaceEthCounts.csv")

race_ethnicity_counts |> count(Race_Ethnicity)

race_ethnicity_counts |>
  mutate(prop_formatted = percent(Prop, accuracy = 0.01)) |>
  filter(Race_Ethnicity %in% c(
    "White",
    "Black",
    "Hispanic/Latino"
  )) |>
  ggplot(
    aes(
      x = Year,
      y = Prop,
      color = Race_Ethnicity,
      group = Race_Ethnicity
    )
  ) +
  geom_line() +
  scale_color_echo() +
  theme_echo(add_y_grid_lines = TRUE)
