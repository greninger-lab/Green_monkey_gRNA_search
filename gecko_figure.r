library(ggplot2)
setwd('/Users/gerbix/Documents/vikas/gecko_green_monkey')

gecko_a_with_pam<-read.csv('/Users/gerbix/Documents/vikas/gecko_green_monkey/gecko_a_with_pam.csv')
gecko_b_with_pam<-read.csv('/Users/gerbix/Documents/vikas/gecko_green_monkey/gecko_b_with_pam.csv')

with_pam_genes_frequency<-data.frame(table(c(as.character(gecko_a_with_pam$with_pam_names), as.character(gecko_b_with_pam$with_pam_names))))

mirna<-which(grepl('mir',with_pam_genes_frequency$Var1))
with_pam_genes_frequency$type<-'RNA'
with_pam_genes_frequency$type[mirna]<-'miRNA'
with_pam_genes_frequency$pam<-'Exact match with PAM'
colnames(with_pam_genes_frequency)<-c('gene','freq','type','pam')


exact_match_gene_counts<-read.csv('/Users/gerbix/Documents/vikas/gecko_green_monkey/exact_match_gene_counts.txt', sep = ' ', header = FALSE)
exact_match_gene_counts$type<-'RNA'
exact_mirna<-which(grepl('mir',exact_match_gene_counts$V2))
exact_match_gene_counts$type[exact_mirna]<-'miRNA'
exact_match_gene_counts$pam<-'Exact match'
colnames(exact_match_gene_counts)<-c('freq','gene','type','pam')
exact_match_gene_counts<-exact_match_gene_counts[,c(2,1,3,4)]

combined<-rbind(exact_match_gene_counts,with_pam_genes_frequency)


pam_RNA_vs_miRNA<-ggplot(with_pam_genes_frequency, aes( x = with_pam_genes_frequency$type)) + 
  geom_bar()

pam_RNA_vs_miRNA


pam_vs_not<-ggplot(combined, aes( x = combined$pam)) + 
  geom_bar(aes(fill = combined$type)) + 
  theme_classic() + 
  theme(legend.title = element_blank()) + 
  theme(axis.text.x = element_text(angle = 30, hjust = 1)) + 
  xlab(NULL)
pam_vs_not
ggsave('exact_matches_miRNA.pdf', height =3, width = 3)


#with_pam_no_mirna<-with_pam_genes_frequency[-mirna,]


