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
    theme(legend.position = "none")
}

theme_set(theme_echo())

# Import Data ------------------------------------------------------------

over_50 <-
  read_csv("data-raw/Elders.csv") |>
  mutate(
    year = factor(Year),
    people = Count,
    prop = Prop,
    people_formatted = comma(Count),
    percent_formatted = percent(Prop, accuracy = 0.01)
  )

# Plot --------------------------------------------------------------------

over_50 |>
  filter(year %in% c("2019","2020","2021","2022","2023")) |>
  ggplot(
    aes(
      x = year,
      y = prop,
      label = paste0(people_formatted, "\n", percent_formatted)
    )
  ) +
  geom_col(fill = echo_yellow, width = 0.6) +
  geom_text(vjust = 0.5, size = 4, lineheight = 1.05) +
  scale_y_continuous(
    labels = percent_format(accuracy = 1),
    breaks = seq(0, 0.4, by = 0.1),
    expand = expansion(mult = c(0, 0.05))
  ) +
  labs(
    title = "People Older Than 50 in the HRS",
    y = "Percent of All People",
    x = NULL
  )
