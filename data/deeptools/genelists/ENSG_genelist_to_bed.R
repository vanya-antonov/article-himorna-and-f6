nc_high <- read.table("../nc_high.txt", header =FALSE, sep = '\t')
nc_low <- read.table("../nc_low.txt", header =FALSE, sep = '\t')
nc_zero <- read.table("../nc_zero.txt", header =FALSE, sep = '\t')

colnames(nc_high) <- c("ensembl_gene_id")
colnames(nc_low) <- c("ensembl_gene_id")
colnames(nc_zero) <- c("ensembl_gene_id")

id_nc_high <- merge(x = nc_high, y = t2g, by = 'ensembl_gene_id', all.x = TRUE)
id_nc_low <- merge(x = nc_low, y = t2g, by = 'ensembl_gene_id', all.x = TRUE)
id_nc_zero <- merge(x = nc_zero, y = t2g, by = 'ensembl_gene_id', all.x = TRUE)

id_nc_high <- na.omit(id_nc_high)
id_nc_low <- na.omit(id_nc_low)
id_nc_zero <- na.omit(id_nc_zero)

id_nc_high$chromosome_name <- paste0(x = "chr", id_nc_high$chromosome_name)
id_nc_low$chromosome_name <- paste0(x = "chr", id_nc_low$chromosome_name)
id_nc_zero$chromosome_name <- paste0(x = "chr", id_nc_zero$chromosome_name)

id_nc_high<-id_nc_high[,c(2,3,4,5)]
id_nc_low<-id_nc_low[,c(2,3,4,5)]
id_nc_zero<-id_nc_zero[,c(2,3,4,5)]

id_nc_high<-id_nc_high[order(id_nc_high$chromosome_name), ]
id_nc_low<-id_nc_low[order(id_nc_low$chromosome_name), ]
id_nc_zero<-id_nc_zero[order(id_nc_zero$chromosome_name), ]

id_nc_high$strand <-replace(id_nc_high$strand, id_nc_high$strand==-1,"-")
id_nc_low$strand <-replace(id_nc_low$strand, id_nc_low$strand==-1,"-")
id_nc_zero$strand <-replace(id_nc_zero$strand, id_nc_zero$strand==-1,"-")

id_nc_high$strand <-replace(id_nc_high$strand, id_nc_high$strand==1,"+")
id_nc_low$strand <-replace(id_nc_low$strand, id_nc_low$strand==1,"+")
id_nc_zero$strand <-replace(id_nc_zero$strand, id_nc_zero$strand==1,"+")

id_nc_high$name<-(x="0")
id_nc_low$name<-(x="0")
id_nc_zero$name<-(x="0")

id_nc_high$phase<-(x="0")
id_nc_low$phase<-(x="0")
id_nc_zero$phase<-(x="0")

id_nc_high<-id_nc_high[,c(1,2,3,5,6,4)]
id_nc_low<-id_nc_low[,c(1,2,3,5,6,4)]
id_nc_zero<-id_nc_zero[,c(1,2,3,5,6,4)]

write.table(data.frame(id_nc_high), "../nc_high.bed", sep = '\t',  quote = F,  row.names = F, col.names = F)
write.table(data.frame(id_nc_low), "../nc_low.bed", sep = '\t',  quote = F,  row.names = F, col.names = F)
write.table(data.frame(id_nc_zero), "../nc_zero.bed", sep = '\t',  quote = F,  row.names = F, col.names = F)
