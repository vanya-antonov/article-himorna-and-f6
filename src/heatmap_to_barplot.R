
library(ggplot2)
library(dplyr) 
library(tidyr)   # gather

###

theme_set(theme_bw(base_size = 19))  # increase the font size: https://stackoverflow.com/a/11955412/310453

#DATA_DIR <- "../data/"
DATA_DIR <- "/Users/ivan/_my/github/article-himorna-and-f6/data/"

###

df <- read.delim(paste0(DATA_DIR, "heatmap_data.genes.tsv"), as.is=TRUE)
head(df)

gg_df <- df %>%
  gather("role", "num_aso", -c("geneName")) %>%
  filter(num_aso > 0) %>%
  group_by(geneName, num_aso) %>%
  summarise(num_roles = n()) %>%
  as.data.frame()

gg_df %>%
  mutate(geneName = factor(geneName, levels = rev(unique(gg_df$geneName)))) %>%
  mutate(num_aso = factor(num_aso, levels = rev(unique(gg_df$num_aso)))) %>%
  ggplot() +
  aes(x = geneName, y = num_roles, fill = num_aso) +
  geom_bar(stat = 'identity', col="black") +
  coord_flip()

  head()
  
  # separate(role, into = c("mark", "type"), sep="\\.") %>%
  head()

?separate

?read.csv

pwd()


