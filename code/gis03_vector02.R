pacman::p_load(tidyverse,
               sf,
               mapview)

rm(list = ls())

sf_site <- readRDS("data/sf_finsync_nc.RDS")
sf_nc_county <- readRDS("data/sf_nc_county.RDS")

mapview(sf_nc_county,
        legend = F) +
  mapview(sf_site,
          legend = F)

sf_site_join <- st_join(x = sf_site,
                        y = sf_nc_county)


sf_site_guilford <- sf_site_join %>% 
  filter(county == "guilford")

sf_site_clay <- sf_site_join %>% 
  filter(county == "clay")

sf_str <- readRDS("data/sf_stream_gi.rds")

ggplot() +
  geom_sf(data = sf_nc_county %>% 
            filter(county == "guilford")) +
  geom_sf(data = sf_str,
          color = "blue") +
  geom_sf(data = sf_site_guilford,
          color = "red") 

sf_str_proj <- st_transform(sf_str,
                            crs = 32617)

v_str_l <- st_length(sf_str_proj)

sf_str_w_l <- sf_str %>% 
  mutate(length = v_str_l)

sf_nc_county_proj <- st_transform(sf_nc_county,
                                  crs = 32617)

v_area <- st_area(sf_nc_county_proj)

sf_nc_county_w_area <- sf_nc_county_proj %>% 
  mutate(area = as.numeric(v_area) / 1E+6)

sf_county1k <- sf_nc_county_w_area %>% 
  filter(area > 1000)

ggplot() +
  geom_sf(data = sf_county1k)

sf_quakes <- readRDS("data/sf_quakes.rds")
sf_nz <- readRDS("data/sf_nz.rds")

mapview(sf_quakes) + mapview(sf_nz)

sf_quakes_join <- st_join(sf_nz,
                          sf_quakes) %>% 
  drop_na()


nrow(sf_quakes_join)

  df_n <- sf_site_join %>% 
    as_tibble() %>% 
    group_by(county) %>% 
    summarize(n_site = n_distinct(site_id)) %>% 
    ungroup()

sf_n_site <- sf_nc_county %>% 
  left_join(df_n,
            by = "county") 

sf_n10 <- sf_n_site %>% 
  filter(n_site > 10)

ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_n_site %>% 
            filter(n_site > 1),
          color = "red") +
  geom_sf(data = sf_n10,
          color = "blue") 