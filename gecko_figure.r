library(ggplot2)
library(wesanderson)

setwd('/Users/gerbix/Documents/vikas/gecko_green_monkey')
'%!in%' <- function(x,y)!('%in%'(x,y))
myBreaks <- function(x){
  breaks <- c(min(x),median(x),max(x))
  names(breaks) <- attr(breaks,"labels")
  breaks
}




#gecko original
gecko_a_original<-read.csv('/Users/gerbix/Documents/vikas/gecko_green_monkey/gecko_a_original.csv')
gecko_a_original$UID<-NULL
gecko_a_original$seq<-NULL
gecko_b_original<-read.csv('/Users/gerbix/Documents/vikas/gecko_green_monkey/gecko_b_original.csv')
gecko_b_original$UID<-NULL
gecko_b_original$seq<-NULL
gecko_original_combined<-data.frame(table(c(as.character(gecko_a_original$gene_id), as.character(gecko_b_original$gene_id))))
gecko_original_mir<-which(grepl('mir',gecko_original_combined$Var1))
gecko_original_combined$type<-'RNA'
gecko_original_combined$type[gecko_original_mir]<-'miRNA'
gecko_original_combined$pam<-'Original'
colnames(gecko_original_combined)<-c('gene','freq','type','pam')
gecko_original_unique<-unique(gecko_original_combined$gene)

#gecko with pam
gecko_a_with_pam<-read.csv('/Users/gerbix/Documents/vikas/gecko_green_monkey/gecko_a_with_pam.csv')
gecko_b_with_pam<-read.csv('/Users/gerbix/Documents/vikas/gecko_green_monkey/gecko_b_with_pam.csv')

with_pam_genes_frequency<-data.frame(table(c(as.character(gecko_a_with_pam$with_pam_names), as.character(gecko_b_with_pam$with_pam_names))))
#adding in any 0s (anything in the original that isn't in this list)
with_pam_genes_0<-data.frame(gecko_original_unique[which(as.character(gecko_original_unique) %!in% unique(as.character(with_pam_genes_frequency$Var1)))])
colnames(with_pam_genes_0)[1]<-'Var1'
with_pam_genes_0$Freq<-0
with_pam_genes_frequency<-rbind(with_pam_genes_frequency,with_pam_genes_0)

mirna<-which(grepl('mir',with_pam_genes_frequency$Var1))
with_pam_genes_frequency$type<-'RNA'
with_pam_genes_frequency$type[mirna]<-'miRNA'
with_pam_genes_frequency$pam<-'Matched + PAM'
colnames(with_pam_genes_frequency)<-c('gene','freq','type','pam')

#gecko exact matches without pam
exact_match_gene_counts<-read.csv('/Users/gerbix/Documents/vikas/gecko_green_monkey/exact_match_gene_counts.txt', sep = ' ', header = FALSE)

#adding in any 0s (anything in the original that isn't in this list)
exact_genes_0<-data.frame(gecko_original_unique[which(as.character(gecko_original_unique) %!in% unique(as.character(exact_match_gene_counts$V2)))])
colnames(exact_genes_0)[1]<-'V2'
exact_genes_0$V1<-0
exact_match_gene_counts<-rbind(exact_match_gene_counts,exact_genes_0)

exact_match_gene_counts$type<-'RNA'
exact_mirna<-which(grepl('mir',exact_match_gene_counts$V2))
exact_match_gene_counts$type[exact_mirna]<-'miRNA'
exact_match_gene_counts$pam<-'Matched'
colnames(exact_match_gene_counts)<-c('freq','gene','type','pam')
exact_match_gene_counts<-exact_match_gene_counts[,c(2,1,3,4)]


combined<-rbind(gecko_original_combined,with_pam_genes_frequency,exact_match_gene_counts)
combined$pam<-as.factor(combined$pam)

pam_RNA_vs_miRNA<-ggplot(with_pam_genes_frequency, aes( x = with_pam_genes_frequency$type)) + 
  geom_bar()

pam_RNA_vs_miRNA

#by miRNA
pam_vs_not<-ggplot(combined, aes( x = combined$pam)) + 
  geom_bar(aes(fill = combined$type)) + 
  theme_classic() + 
  theme(legend.title = element_blank()) + 
  theme(axis.text.x = element_text(angle = 30, hjust = 1)) + 
  xlab(NULL)
pam_vs_not
ggsave('exact_matches_miRNA.pdf', height =3, width = 3)

#by frequency (with miRNA)
pam_vs_not<-ggplot(combined, aes( x = combined$freq)) + 
  geom_histogram(aes(fill = as.factor(pam))) + 
  theme_classic() + 
  theme(legend.title = element_blank()) + 
  theme(axis.text.x = element_text(angle = 30, hjust = 1)) + 
  scale_x_continuous(breaks=0:6, labels=c(0,1,2,3,4,5,6))  + 
  #scale_y_log10() + 
  xlab(NULL)
pam_vs_not
ggsave(plot = pam_vs_not,'frequencies_by_sample.pdf', height =3, width = 5)

#by frequency without miRNA 
combined_no_mirna<-combined[-which(combined$type=='miRNA'),]

pam_vs_not<-ggplot(, aes( x = freq)) + 
  geom_histogram(aes(fill = as.factor(pam))) + 
  theme_classic() + 
  theme(legend.title = element_blank()) + 
  theme(axis.text.x = element_text(angle = 30, hjust = 1)) + 
  scale_x_continuous(breaks=0:6, labels=c(0,1,2,3,4,5,6))  + 
  #scale_y_log10() + 
  xlab(NULL)
pam_vs_not
ggsave(plot = pam_vs_not,'frequencies_by_sample_no_miRNA.pdf', height =3, width = 5)




gecko_origina_nomirna<-ggplot(combined_no_mirna, aes( x = pam, y = 1)) + 
  geom_bar(stat = "identity", aes(fill = as.factor(freq))) + 
  #geom_text(aes(label=freq, y = freq), size=3) + 
  theme_classic() + 
  theme(legend.title = element_blank()) + 
  #geom_label(aes(label = freq),position = position_stack(vjust = 0.5),size = 2.75,color = 'white') + 
  scale_fill_brewer(palette="Set2") +
  #xlim(c(0,25000)) +
  #scale_y_continuous(breaks = myBreaks, limits = c(0,25000))+
  scale_y_continuous(breaks = c(0,5500,11000,16500,22000), limits = c(0,22000)) + 
  xlab(NULL) + 
  ylab('Counts')
gecko_origina_nomirna
ggsave(plot = gecko_origina_nomirna,'no_mirna_3_column_frequencies.pdf', height =3, width = 3)

combined<-combined[combined$freq!=8,]

gecko_original<-ggplot(combined, aes( x = pam, y = 1))  + 
  geom_bar(stat = "identity", aes(fill = as.factor(freq))) + 
  #geom_text(aes(label=freq, y = freq), size=3) + 
  theme_classic() + 
  theme(legend.title = element_blank()) + 
  theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
  scale_fill_brewer(palette="Set2") +
  #xlim(c(0,25000)) +
  #scale_y_continuous(breaks = myBreaks, limits = c(0,25000))+
  scale_y_continuous(breaks = c(0,5500,11000,16500,22000), limits = c(0,22000)) + 
  xlab(NULL) + 
  ylab('Counts')
gecko_original
ggsave(plot = gecko_original,'3_column_frequencies.pdf', height =3, width = 3)



sum(combined_no_mirna$freq[combined_no_mirna$pam=='Matched']) + length(combined_no_mirna$freq[combined_no_mirna$pam=='Matched' & combined_no_mirna$freq==0]) 
sum(combined_no_mirna$freq[combined_no_mirna$pam=='Matched + PAM']) + length(combined_no_mirna$freq[combined_no_mirna$pam=='Matched + PAM' & combined_no_mirna$freq==0]) 


summary_table<-t(data.frame(table(gecko_original_combined$freq)))
summary_table<-rbind(summary_table,t(data.frame(table(exact_match_gene_counts$freq))[2]))
summary_table<-rbind(summary_table,t(data.frame(table(with_pam_genes_frequency$freq))[2]))
rownames(summary_table)<-c('matches','original','matched','matched with pam')

write.csv(summary_table, 'matches_summarized.csv')
write.csv(combined, 'all_gene_counts.csv')















