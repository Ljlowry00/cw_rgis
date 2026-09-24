#Vector 1

pacman::p_load(tidyverse,
               sf,
               mapview)

sf_nc_county <- st_read(dsn = "data/nc.shp",
                        quiet = T)

st_write(sf_nc_county,
         dsn = "data/sf_nc_county.shp",
         append = F)

saveRDS(sf_nc_county,
        file = "data/sf_nc_county.rds")

sf_nc_county <- readRDS(file = "data/sf_nc_county.rds")

sf_site <- readRDS("data/sf_finsync_nc.rds")

mapview(sf_site,
        col.regions = "black",
        legend = F)

sf_site_f10 <- sf_site %>% 
  slice(1:10)

mapview(sf_site_f10,
        col.regions = "tomato",
        legend = F)

sf_str <- readRDS("data/sf_stream_gi.rds")

mapview(sf_str,
        color = "salmon",
        legend = F)

sf_nc_county <- readRDS("data/sf_nc_county.rds")
mapview(sf_nc_county,
        legend = F,
        col.region = "darkgreen")

sf_nc_guilford <- sf_nc_county %>% 
  filter(county == "guilford") 

mapview(sf_nc_guilford)

ggplot() +
  geom_sf(data = sf_nc_guilford) +
  geom_sf(data = sf_str)

ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str) +
  geom_sf(data = sf_site)

sf_str_as <- readRDS("data/sf_stream_as.rds")
print(sf_str_as)
print(sf_nc_county)

ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str_as) 

ggplot() +
  geom_sf(data = sf_nc_county %>% 
            filter(county == "ashe")) +
  geom_sf(data = sf_str_as) 
  