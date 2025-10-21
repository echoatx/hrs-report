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

# Plot -----------------Client histogram---------------------------

client_years <-
  read_csv("data-raw/Client_Counts.csv")

clients_overTime <- ggplot(client_years,
                           aes(x = factor(Year),  
                               y = n)) +
  geom_col(fill = "#1c4750", width = .6) +
  geom_text(aes(label = comma(n)),
            color = 'black',
            family = 'Lora',
            vjust = -.3,
            size = 24 / .pt) +
  scale_y_continuous(
    limits = c(0, 30000),
    breaks = seq(0, 30000, by = 10000),
    labels = comma,
    expand = c(0, 0.)
  ) +
  labs(x = NULL, y = "People Served") +
  theme_classic() +
  theme(
    text = element_text(family = 'Lora'),
    legend.position = 'none',
    panel.grid.minor.x = element_blank(),
    axis.title = element_text(size = 24),
    axis.text = element_text(size = 24)
  )


