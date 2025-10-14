# Load Packages -----------------------------------------------------------


library(tidyverse)
library(scales)


# Define Colors -----------------------------------------------------------

echo_blue <- "#2373b9"
echo_yellow <- "#f0b405"
echo_green <- "#50dc69"


# Define Theme ------------------------------------------------------------

theme_echo <- function() {
  theme_classic(
    base_size = 16,
    base_family = "Lora"
  ) +
    theme(legend.position = "bottom")
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
  scale_fill_manual(
    values = c(
      "Minimal Housing Assistance" = echo_blue,
      "Permanent Supportive Housing" = echo_yellow,
      "Rapid Re-Housing" = echo_green
    )
  ) +
  labs(
    y = "People",
    x = NULL,
    fill = NULL
  )
