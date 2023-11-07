
library(ggplot2)
library(dplyr) 
library(tidyr)   # gather

###

theme_set(theme_bw(base_size = 19))  # increase the font size: https://stackoverflow.com/a/11955412/310453

#DATA_DIR <- "../data/"
DATA_DIR <- "/Users/ivan/_my/github/article-himorna-and-f6/data/"
OUT_DIR <- "../images/"

SIGNS_TO_ROLES <- c(
  'pm' = "Writer of an Active mark (wa)",
  "pp" = "Writer of a Repressive mark (wr)",
  "mp" = "Eraser of an Active mark (ea)",
  "mm" = "Eraser of a Repressive mark (er)"
)

###

df <- read.delim(paste0(DATA_DIR, "all_pvalues.tsv"), as.is=TRUE)

gg_df <- df %>%
  gather("pvalue_type", "pvalue", -c("lncRNAId", "lncRNAName", "mark_name")) %>%
  filter(pvalue_type %in% c("mm_adj_pvalue", "pm_adj_pvalue", "mp_adj_pvalue", "pp_adj_pvalue")) %>%
  mutate(log_pvalue = -log10(pvalue)) %>%
  # mm_adj_pvalue  =>  mm
  mutate(pvalue_type = gsub("_adj_pvalue", "", pvalue_type)) %>%
  mutate(role = SIGNS_TO_ROLES[pvalue_type])
head(gg_df)

num_good_points <- gg_df %>%
  filter(log_pvalue >= 1.3) %>%
  nrow()

gg_df %>%
  ggplot() +
  aes(x = mark_name, y=log_pvalue, shape=role) +
  # geom_point(position = "jitter") +
  geom_jitter(width = 0.1) +
  xlab("") +
  ylab("-log10(adj p-value)") +
  geom_hline(yintercept = -log10(0.05), col="red") +
  ggtitle("Without iMargi", subtitle = paste0("Number of cases with adj p-value < 0.05 = ", num_good_points)) +
  coord_flip() +
  theme(legend.position="bottom", legend.title=element_blank()) +
  guides(shape=guide_legend(ncol=2))
ggsave('all_pvalues.wo_imargi.pdf', path = OUT_DIR, height = 10, width = 10)
