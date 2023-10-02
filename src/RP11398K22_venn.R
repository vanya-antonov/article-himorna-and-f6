
source('lib.R')

library(VennDiagram)

###

fantom_df  <- read.delim(paste0(DATA_DIR, 'ENSG00000229852.fantom_two_aso.DE_Summary.txt'), as.is=TRUE, header=TRUE)
himorna_df <- read.delim(paste0(DATA_DIR, 'ENSG00000229852_H3K27ac.himorna_peaks_anno.txt'), as.is=TRUE, header=TRUE)
#atac_df    <- read.delim(paste0(DATA_DIR, 'ENSG00000229852.atac_diff_peaks_anno.txt'), as.is=TRUE, header=TRUE)
imargi_df <- read.delim(paste0(DATA_DIR, 'ENSG00000229852.imargi_peaks_anno.txt'), as.is=TRUE, header=TRUE)

###
# Genes Venn

fantom_v <- fantom_df %>%
  filter(log2FC < 0) %>%
  pull(geneID) %>%
  unique()

himorna_v <- himorna_df %>%
  filter(!is.na(feature)) %>%
  # ENSG00000189337.17  =>  ENSG00000189337
  mutate(geneID = gsub('\\.\\d+$', '', feature, perl=TRUE)) %>%
  pull(geneID) %>%
  unique()

imargi_v <- imargi_df %>%
  filter(!is.na(feature)) %>%
  # ENSG00000189337.17  =>  ENSG00000189337
  mutate(geneID = gsub('\\.\\d+$', '', feature, perl=TRUE)) %>%
  pull(geneID) %>%
  unique()

common3_v <- Reduce(intersect, list(fantom_v, himorna_v, imargi_v))

# Do not create log file: https://stackoverflow.com/a/36812214/310453
futile.logger::flog.threshold(futile.logger::ERROR, name = "VennDiagramLogger")

venn.diagram(
  x = list(fantom_v, himorna_v, imargi_v),
  category.names = c(
    paste("FANTOM Downregulated genes,\nn = ", length(fantom_v)),
    paste("HiMoRNA genes,\nn = ", length(himorna_v)),
    paste("iMARGI genes, n = ", length(imargi_v))),
  cat.fontface = "bold",
  cat.pos = c(-15, 15, 180),
  cat.dist = c(0.05, 0.05, 0.02),
  filename = paste0(OUT_DIR, 'RP11398K22_venn_genes.png'),
  output=TRUE
)


###
# ASO Venn ----

aso_05_v <- fantom_df %>%
  filter(perturb_id == 'ASO_G0229852_05') %>%
  filter(log2FC < 0) %>%
  pull(geneID) %>%
  unique()

aso_03_v <- fantom_df %>%
  filter(perturb_id == 'ASO_G0229852_03') %>%
  filter(log2FC < 0) %>%
  pull(geneID) %>%
  unique()

venn.diagram(
  x = list(aso_05_v, aso_03_v, himorna_v),
  category.names = c(
    paste("FANTOM ASO_G0229852_05\ndownregulated genes, n = ", length(aso_05_v)),
    paste("FANTOM ASO_G0229852_03\ndownregulated genes, n = ", length(aso_03_v)),
    paste("HiMoRNA genes, n = ", length(himorna_v))),
  cat.fontface = "bold",
  cat.pos = c(-15, 15, 180),
  cat.dist = c(0.06, 0.06, 0.02),
  filename = paste0(OUT_DIR, 'RP11398K22_venn_aso.png'),
  output=TRUE
)

# Common genes - ENSG00000113578 (FGF1)
Reduce(intersect, list(himorna_v, aso_05_v, aso_03_v))


###
# get the log2FC

head(fantom_df)

# ASO_G0229852_03 -0.3826788
fantom_df %>%
  filter(geneSymbol == 'E2F7')

