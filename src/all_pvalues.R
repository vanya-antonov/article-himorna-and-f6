
library(ggplot2)
library(dplyr) 
library(tidyr)   # gather

###

theme_set(theme_bw(base_size = 19))  # increase the font size: https://stackoverflow.com/a/11955412/310453

#DATA_DIR <- "../data/"
DATA_DIR <- "/Users/ivan/_my/github/article-himorna-and-f6/data/"
OUT_DIR <- "../images/"

###

df <- read.delim(paste0(DATA_DIR, "all_pvalues.tsv"), as.is=TRUE)
head(df)

df %>%
  gather("pvalue_type", "pvalue", -c("lncRNAId", "lncRNAName", "mark_name")) %>%
  filter(pvalue_type %in% c("mm_adj_pvalue", "pm_adj_pvalue", "mp_adj_pvalue", "pp_adj_pvalue")) %>%
  mutate(log_pvalue = -log10(pvalue)) %>%
  ggplot() +
  aes(x = mark_name, y=log_pvalue, shape=pvalue_type) +
  geom_point(position = "jitter") +
  ylim(0, 20) +
  ylab("-log10(adj p-value)") +
  geom_hline(yintercept = -log10(0.05), col="red") +
  coord_flip()
ggsave('all_pvalues.pdf', path = OUT_DIR, height = 10, width = 10)
