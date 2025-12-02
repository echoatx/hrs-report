library(tidyverse)
library(sf)
library(tigris)
library(janitor)

# Travis County ----------------------------------------------------------

texas_counties <-
  counties(state = "TX")

travis_county <-
  texas_counties |>
  select(NAME) |>
  filter(NAME == "Travis")

travis_county |>
  write_sf("data/travis_county.geojson")

# Roads ------------------------------------------------------------------

texas_roads <- primary_secondary_roads(state = "TX")

travis_county_roads <-
  texas_roads |>
  st_intersection(travis_county)

travis_county_roads |>
  write_sf("data/travis_county_roads.geojson")

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

psh_providers_sf |>
  write_sf("data/psh_providers_sf.geojson")
