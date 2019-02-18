library(ggplot2)
library(gridExtra)
library(dplyr)
library(RColorBrewer)

sumstats = read.csv("sumstats_jgi.csv",header=TRUE,stringsAsFactors=TRUE)
pdf(sprintf("%s/%s","plots","summary_stats.pdf"),onefile=TRUE)

p <- ggplot(sumstats, aes(x=intronlen_mean,y=intronct_mean)) + geom_point() + 
  theme_minimal() + ggtitle("Intron size vs occurance in genes (mean)") +
    scale_color_brewer(palette="Set1") + theme(legend.position="none")
print(p)

p <- ggplot(sumstats, aes(x=intronlen_mean,y=exonlen_mean)) + geom_point() + 
  theme_minimal() + ggtitle("Intron size vs exon size genes (mean)") +
    scale_color_brewer(palette="Set1") + theme(legend.position="none")
print(p)


p <- ggplot(sumstats, aes(x=intronlen_mean,y=exonlen_mean)) + geom_point() + 
  theme_minimal() + ggtitle("Intron size vs exon size genes (mean)") +
    scale_color_brewer(palette="Set1") + theme(legend.position="none")
print(p)

p <- ggplot(sumstats, aes(x=genome_size,y=genect)) + geom_point() + 
  theme_minimal() + ggtitle("Genome size vs Gene Count") +
    scale_color_brewer(palette="Set1") + theme(legend.position="none")
print(p)
