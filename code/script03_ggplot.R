library(tidyverse)
rm(list = ls())

iris %>% 
  ggplot(aes(x = Sepal.Length,
        y = Sepal.Width)
        ) +
  geom_point()

iris %>% 
  ggplot(aes(x = Sepal.Length,
             y = Sepal.Width,
             color = Species)) +
  geom_point()

iris %>% 
  ggplot(aes(x = Sepal.Length,
             y = Sepal.Width)) +
  geom_point(color = "darkgreen")


# Line fig ----------------------------------------------------------------

df_x <- tibble(x = 1:50,
       y = 2 * x)

df_x %>% 
  ggplot(aes(x = x,
             y = y)) +
  geom_line()


# histogram ---------------------------------------------------------------

iris %>% 
  ggplot(aes(x = Sepal.Length)) +
  geom_histogram()


# boxplot -----------------------------------------------------------------

iris %>% 
  ggplot(aes(x = Species,
             y = Sepal.Length)) +
  geom_boxplot()


# change color ------------------------------------------------------------

iris %>% 
  ggplot(aes(x = Species,
             y = Sepal.Length,
             color = Species)) + 
  geom_boxplot()

iris %>% 
  ggplot(aes(x = Species,
             y = Sepal.Length,
             fill = Species)) +
  geom_boxplot()

#exercise 

arrange(iris, 
          desc(Sepal.Length))

iris %>% 
  filter(Sepal.Width > 3.0)

df_petal <- iris %>% 
  select(c(Petal.Length, Petal.Width)) %>% 
  arrange(desc(Petal.Length))

df_mean <- iris %>% 
    group_by(Species) %>% 
    mutate(mean(Sepal.Width))

iris %>% 
  ggplot(aes(x = Sepal.Width,
             y = Petal.Width,
             color = Species)) +
  geom_point()
