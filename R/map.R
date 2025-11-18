library(tidyverse)
library(sf)
library(tigris)
library(janitor)

# Geospatial data --------------------------------------------------------

us_states <-
  states() |>
  select(NAME)

texas <-
  us_states |>
  filter(NAME == "Texas")

texas |>
  ggplot() +
  geom_sf()


# Travis County ----------------------------------------------------------

texas_counties <-
  counties(state = "TX")

travis_county <-
  texas_counties |>
  select(NAME) |>
  filter(NAME == "Travis")

travis_county |>
  ggplot() +
  geom_sf()


# Roads ------------------------------------------------------------------

texas_roads <- primary_secondary_roads(state = "TX")

travis_county_roads <-
  texas_roads |>
  st_intersection(travis_county)

# Primary Supportive Housing Providers -----------------------------------

psh_providers <-
  read_csv("data-raw/psh-providers.csv") |>
  clean_names()

psh_providers_sf <-
  psh_providers |>
  drop_na(coordinates) |>
  separate_wider_delim(coordinates, delim = ", ", names = c("lat", "lon")) |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326) |>
  mutate(name = str_remove(name, " \\(.*")) |>
  mutate(name = str_wrap(name, 15))


# Geocoding --------------------------------------------------------------

library(tidygeocoder)

# Map --------------------------------------------------------------------

library(ggrepel)

ggplot() +
  geom_sf(data = travis_county, fill = "#dce6dc") +
  geom_sf(data = travis_county_roads, color = "#b9bab9", linewidth = 0.25) +
  geom_sf(data = psh_providers_sf, color = "#423070", size = 1) +
  geom_label_repel(
    data = psh_providers_sf,
    stat = "sf_coordinates",
    max.overlaps = 100,
    min.segment.length = 0,
    color = "#423070",
    size = 2,
    lineheight = 0.9,
    aes(label = name, fill = year_operational, geometry = geometry)
  ) +
  theme_void()

psh_providers_sf |>
  pull(name)
