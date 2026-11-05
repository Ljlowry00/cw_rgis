#Raster-vector interactions

pacman::p_load(tidyverse,
               sf, 
               terra,
               tidyterra,
               exactextractr)

sf_nc_county <- readRDS("data/sf_nc_county.rds")
sf_site <- readRDS("data/sf_finsync_nc.rds")
spr_prec_nc <- rast("data/spr_prec_nc.tif")

#point wise extraction

ggplot() + 
  geom_spatraster(data = spr_prec_nc) + 
  geom_sf(data = sf_site) + 
  scale_fill_viridis_c()

extract(x = spr_prec_nc, #data layer
        y = sf_site, #spatial layer
        bind = T
        ) %>% 
  st_as_sf()

#zonal stats

sf_nc_county_proj <- st_transform(sf_nc_county,
                                  crs = 32617) 

spr_prec_nc_proj <- project(x = spr_prec_nc,
                            y = crs(sf_nc_county_proj))

ggplot() + 
  geom_spatraster(data = spr_prec_nc) + 
  geom_sf(data = sf_nc_county,
          alpha = .25)

df_prec_county <- exact_extract(x = spr_prec_nc_proj,
              y = sf_nc_county_proj,
              fun = "mean",
              append_cols = "county") %>% 
  as_tibble() %>% 
  rename(precip = mean)

sf_nc_county_prec <- sf_nc_county %>% 
  left_join(df_prec_county,
            by = "county")

ggplot() + 
  geom_sf(data = sf_nc_county_prec,
          aes(fill = precip)) + 
  scale_fill_viridis_c()

sf_nc_county_prec %>% 
  arrange(precip)

#buffer based analysis
sf_site_proj <- sf_site %>% 
  st_transform(crs = 32617) 

sf_site_buff_proj <- sf_site_proj %>% 
  st_buffer(dist = 10000) 


ggplot() + 
  geom_sf(data = sf_site_buff_proj) + 
  geom_sf(data = sf_site_proj) 

df_prec_buff <- exact_extract(x = spr_prec_nc_proj,
                y = sf_site_buff_proj,
                fun = "mean",
                append_cols = "site_id") %>% 
  as_tibble() %>% 
  rename(precip = mean)

sf_site_pre_buff <- sf_site %>% 
  left_join(df_prec_buff,
            by = "site_id")

ggplot() + 
  geom_sf(data = sf_nc_county) + 
  geom_sf(data = sf_site_pre_buff,
           aes(color = precip)) + 
  scale_fill_viridis_c()


spr_land <- rast("data/spr_land_reclass.tif")
  
cm_1 <- cbind(c(0, 1001, 1010, 1100),
              c(0, 0, 1, 0))

spr_land_bin <- classify(spr_land,
                         rcl = cm_1) %>% 
  project(x = ,
          y =crs(sf_nc_county_proj))

df_crop_perc <- exact_extract(x = spr_land_bin,
                              y = sf_nc_county_proj,
                              fun = "mean",
                              append_cols = "county") %>% 
  as_tibble() %>% 
  rename(crop_frac = mean)



ggplot() + 
  geom_sf(data = left_join(sf_nc_county_proj,
                           df_crop_perc,
                           by = "county"),
          aes(fill = crop_frac)) 

