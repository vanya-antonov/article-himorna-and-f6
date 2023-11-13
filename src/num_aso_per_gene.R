
source('lib.R')

###

aso_names_df <- read.delim(paste0(DATA_DIR, 'ASO_names.info'), as.is=TRUE, header=TRUE)
head(aso_names_df)

all_pvalues_df <- read.delim(paste0(DATA_DIR, 'all_pvalues.tsv'), as.is=TRUE, header=TRUE)
head(all_pvalues_df)

# 105 unique ASO_ids
analyzed_aso_df <- all_pvalues_df %>%
  select(lncRNAId, lncRNAName) %>%
  separate(lncRNAId, c('geneID', 'aso_id'), sep = "_ASO_", remove = FALSE) %>%
  mutate(aso_id = paste0("ASO_", aso_id)) %>%
  select(aso_id) %>%
  distinct()
head(analyzed_aso_df)
nrow(analyzed_aso_df)

# There are 3 missing ASOs in the ASO_names.info:
# 1      ASO_C013368_02
# 2      ASO_C013368_01
# 3 ASO_G0228630_POS_06
analyzed_aso_df %>% filter(!aso_id %in% aso_names_df$aso_id)

# Let's ignore them: 105 => 102 ASO_IDs
analyzed_aso_df <- inner_join(aso_names_df, analyzed_aso_df, by="aso_id")
head(analyzed_aso_df)
nrow(analyzed_aso_df)

geneName_v <- analyzed_aso_df$geneName %>% unique() %>% sort()
subT <- paste0("Total number of knockdown experiments = ", nrow(analyzed_aso_df))
analyzed_aso_df %>%
  group_by(geneName, geneType) %>%
  summarise(num_aso = n()) %>%
  mutate(geneName = factor(geneName, levels=rev(geneName_v))) %>%
  ggplot() +
  aes(x = geneName, y = num_aso, fill=geneType) +
  geom_bar(stat = "identity", col ="black", width = 0.7) +
  xlab("lncRNA name") +
  ylab("Number of knockdown experiments") +
  ggtitle(paste0("Total number of lncRNAs = ", length(geneName_v)), subtitle = subT) +
  coord_flip() +
  theme(legend.position="bottom", legend.title=element_blank())
ggsave('num_aso_per_gene.pdf', path = OUT_DIR, height = 15, width = 10)

