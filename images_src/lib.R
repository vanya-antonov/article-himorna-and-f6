
library(ggplot2)
# library(cowplot)   # To have ggplots side-by-side: plot_grid()

library(dplyr)
library(tidyr)     # separate(), gather() and spread() functions
library(tibble)    # for rownames_to_column() and column_to_rownames()

# library(ComplexHeatmap)
#library(circlize)   # colorRamp2()


theme_set(theme_bw(base_size = 19))  # increase the font size: https://stackoverflow.com/a/11955412/310453

###

DATA_DIR <- "../data/"
OUT_DIR <- "../images/"

# ???
# We used 45480 as the total number of the human genes that was computed
# as the sum of the protein-coding (19954), long (17957) and small (7569) non-coding RNA genes
# as annotated in the GENCODE version 35.
# NUM_HUMAN_GENES <- 45480

