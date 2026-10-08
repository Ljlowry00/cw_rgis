pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
               stars)

spr_ex <- rast("data/spr_example.tif")

writeRaster(x = spr_ex,
            filename = "data/spr_elev.tif",
            overwrite = T)

ggplot() + 
  geom_spatraster(data = spr_ex)

star_ex <- st_as_stars(spr_ex)
mapview(star_ex)

v_elev <- values(spr_ex)


extract(spr_ex,
        y = cbind(rnorm(n = 1, mean = 6),
                  rnorm(n = 1, mean = 50)
        ))

df_point <- tibble(
  lon = c(6, 5.9),
  lat = c(50, 49.96)
)

extract(spr_ex,
        y = df_point)

spr_for <- rast("data/spr_forest_nc.tif")

ggplot() + 
  geom_spatraster(data = spr_for)

v_binary <- values(spr_for)

mean(v_binary) * 100


spr_land <- rast("data/spr_land_reclass.tif")
unique(spr_land)
# 1001 = forest
# 1010 = crop
# 1100 = urban

# coord, -79.8063, 36.0701

extract(spr_land,
        y = cbind(-79.8063,
                  36.0701
        ))

cm <- cbind(c(0, 1001, 1010, 1100),
            c(0, 1, 0, 0))

spr_bin <- classify(spr_land,
                    rcl = cm)

v_bin <- values(spr_bin)
mean(v_bin) * 100
  
  
cm_1 <- cbind(c(0, 1001, 1010, 1100),
              c(0, 0, 1, 0))
cm_2 <- cbind(c(0, 1001, 1010, 1100),
              c(0, 0, 0, 1))
cm_3 <- cbind(c(0, 1001, 1010, 1100),
              c(1, 0, 0, 0))


v_bin_1 <- values(classify(spr_land,
                         rcl = cm_1))
mean(v_bin_1) * 100
#crop 9%

v_bin_2 <- values(classify(spr_land,
                           rcl = cm_2))
mean(v_bin_2) * 100
#urban 3%

v_bin_3 <- values(classify(spr_land,
                           rcl = cm_3))
mean(v_bin_3) * 100
#everything else 19%

spr_prec_ncne <- rast("data/spr_prec_ncne.tif")

# nrow by ncol = 162 by 532
# resolution = 0.008333333, 0.008333333
# extent lat = (-79.89181, -75.45847) 
#        lon = (35.24153, 36.591)
# crs = WGS 84
# min = 1063, max = 1501

ggplot() + 
  geom_spatraster(data = spr_prec_ncne)

sf_site <- readRDS("data/sf_finsync_nc.rds")

df_xy <- st_coordinates(sf_site)

extract(spr_land,
        df_xy) %>% 
  group_by(code) %>% 
  summarize(n_code = n())

table(extract(spr_land,
              df_xy))