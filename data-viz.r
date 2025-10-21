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

# Comparison of Census and HMIS Data --------

AllClients <- client_universe$year_2019 |> 
  mutate(Year = 2019) |>
  bind_rows(
    client_universe$year_2020 |>
      mutate(Year = 2020)
  ) |>
  bind_rows(
    client_universe$year_2021 |>
      mutate(Year = 2021)
  ) |>
  bind_rows(
    client_universe$year_2022 |>
      mutate(Year = 2022)
  ) |>
  bind_rows(
    client_universe$year_2023 |>
      mutate(Year = 2023)
  ) |>
  bind_rows(
    client_universe$year_2024 |>
      mutate(Year = 2024)
  )

traviscounty_race_22 <- read_csv("data/pop_race_eth_2022.csv")

traviscounty_race_22 <- traviscounty_race_22 %>% 
  mutate(Race_Ethnicity = case_when(RACE == 'American Indian and Alaska Native alone' ~ "American Indian",
                                    RACE == 'Asian alone' ~ 'Asian',
                                    RACE == 'Black alone' ~ 'Black',
                                    HISP == 'Hispanic' ~ 'Hispanic/Latino',
                                    RACE == 'Native Hawaiian and Other Pacific Islander alone' ~ 'Pacific Islander',
                                    RACE == 'Two or more races' ~ 'Two or more races',
                                    RACE == 'White alone' ~ 'White')) %>% 
  rename("prop_census_22" = "prop") %>%
  select(Race_Ethnicity, value, prop_census_22, Percent)

RaceEthYears <- AllClients |> 
  count(Year, Race_Ethnicity) |> 
  group_by(Year) |> 
  mutate(Prop = n / sum(n)) |> 
  ungroup()

client_raceeth_24 <- RaceEthYears |> 
  filter(Year == 2024,
         Race_Ethnicity != "Middle Eastern / North African" & Race_Ethnicity != "Data not collected")

census_race_comp_24 <- client_raceeth_24 |> 
  left_join(traviscounty_race_22, by = "Race_Ethnicity") |> 
  mutate(Percent_HRS = round(Prop * 100, 1),
         Percent_Census = round(Percent, 1)) |> 
  select(Race_Ethnicity, Percent_HRS, Percent_Census)

raceEth_census <-ggplot(census_race_comp_long_24, aes(fill = fct_rev(Data_Type), 
                                     y = Data, 
                                     x = fct_reorder(Race_Ethnicity, Data))) +
  geom_bar(position = "dodge", stat = "identity") +
  geom_text(aes(label = Data),
            family = 'Lora', size = 20 / .pt,
            hjust = -0.2,
            # size = 7,
            position = position_dodge(.9)) + 
  labs(x = "Race or Ethnicity",
       y = "Percent of Population") +
  scale_fill_discrete(labels=c('2024 HMIS Enrollments', 'Travis County Population')) +
  coord_flip() +
  ylim(0, 60) +
  theme(text = element_text(family = 'Lora'),
        legend.position = 'bottom',
        legend.text = element_text(size = 14), 
        legend.title = element_blank(),
        legend.key.size = unit(.25, "cm"),
        # panel.background = element_blank(),
        # panel.grid.major = element_line(color = "black",
        #                                   size = 0.01),
        plot.caption = element_text(size = 14),
        axis.ticks = element_blank(),
        axis.title.x = element_text(size = 18),
        axis.text.x = element_text(size = 18),
        # axis.ticks.length = unit(.01, "cm"),
        axis.line.x = element_line(color="black", linewidth = .01),
        axis.line.y = element_line(color="black", linewidth = .01))

raceEth_census


# Household Types -----------------

runHHType <- function(.data) {
    
  .data |>
    mutate(Year = year(EntryDate)) |>
    group_by(HouseholdID)|>
    distinct(HouseholdID, .keep_all = TRUE)|>
    ungroup() |>
    group_by(HHType)|>
    summarise(count = n(),
              Year = unique(Year))|>
    ungroup()|>
    mutate(prop = count / sum(count)) |>
    arrange(prop)|>
    mutate(total = sum(count))
}

HHYears <- yearlyInflow$year2019$data$inflow |>
  runHHType() |>
  bind_rows(
    yearlyInflow$year2020$data$inflow |>
      runHHType() |>
      bind_rows(
        yearlyInflow$year2021$data$inflow |>
          runHHType()
      ) |>
      bind_rows(
        yearlyInflow$year2022$data$inflow |>
          runHHType()
      ) |>
      bind_rows(
        yearlyInflow$year2023$data$inflow |>
          runHHType()
      ) |>
      bind_rows(
        yearlyInflow$year2024$data$inflow |>
          runHHType()
      )
  ) |>
  rename("Household Type" = HHType)

HHPlotV3 <- ggplot(data = HHYears,
       aes(
         x = factor(Year),
         y = count,
         fill = `Household Type`)) +
  geom_col(position = 'dodge') +
  geom_text(aes(label = paste0(comma(count))),
            position = position_dodge(width = .9),
            vjust = -0.3,
            color = 'black',
            family = 'Lora',
            size = 14 / .pt,
            lineheight = 0.32) +
  scale_y_continuous(labels = comma,
                     limits = c(0,10000)) +
  scale_fill_manual(values = c("#1c4750", "#ad363d", "#98942b", "#0587cc")) +
  labs(x = NULL,
       y = NULL, 
       color = 'Household Type') +
  theme_classic() +
  theme(text = element_text(family = 'Lora'),
        legend.position = 'bottom',
        legend.margin = margin(1, 0, 0.5, 0),
        # legend.title = element_blank(),
        legend.text = element_text(size = 12),
        legend.key.height = unit(.01, "cm"),
        # legend.key.width = unit(.01, "cm"),
        legend.box.spacing = margin(0.5),
        panel.background = element_blank(),
        plot.caption = element_text(size = 14),
        axis.title.x = element_text(size = 24),
        axis.text.x = element_text(size = 24),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank())
