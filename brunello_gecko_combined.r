library(Rsamtools)
library(Biostrings)
library(svMisc)
library(ggplot2)
library(wesanderson)
library(svMisc)

setwd('/Users/gerbix/Documents/vikas/gecko_green_monkey/')

brunello<-read.csv('/Users/gerbix/Documents/vikas/gecko_green_monkey/brunello/all_gene_counts.csv')
#removing NTC
to_remove<-which(grepl('Non-',brunello$gene))
brunello<-brunello[-to_remove,]


gecko<-read.csv('/Users/gerbix/Documents/vikas/gecko_green_monkey/all_gene_counts.csv')
#removing NTC
to_remove<-which(grepl('mir',gecko$gene))
gecko<-gecko[-to_remove,]
to_remove<-which(grepl('NonT',gecko$gene))
gecko<-gecko[-to_remove,]



brunello_unique_genes<-unique(brunello$gene)
gecko_unique_genes<-unique(gecko$gene)



#datasets do not contain the same number of genes. There are more in gecko due to miRNAs and some in Brunello not in gecko 
brunello_not_in_gecko<-as.character(brunello_unique_genes[!(brunello_unique_genes %in% gecko_unique_genes)])
gecko_not_in_brunello<-as.character(gecko_unique_genes[!(gecko_unique_genes %in% brunello_unique_genes)])
uniques<-c(brunello_not_in_gecko, gecko_not_in_brunello)


originals_combined<-rbind(brunello[brunello$pam=='Original',],gecko[gecko$pam=='Original',])
originals_combined<-originals_combined[order(originals_combined$gene),]
originals_summed<-setNames(data.frame(matrix(ncol = 5, nrow = 0)), colnames(originals_combined))
#originals_combined is sorted alphabetically by gene. The loop checks if gene[i] == gene[i + 1] and if it does sums them and appends it to a new data frame
##problem is when we hit unique genes 
for(i in 1:nrow(originals_combined)){ 
  progress(i, nrow(originals_combined))
  if((i+1) < nrow(originals_combined) & originals_combined$gene[i] == originals_combined$gene[i+1]){ 
    temp<-originals_combined[i,]
    temp$freq<- originals_combined$freq[i] + originals_combined$freq[i+1]
    originals_summed<-rbind(originals_summed,temp)
    }
}

originals_summed_with_uniques<-originals_summed
for(i in 1:length(uniques)){ 
  temp<-which(originals_combined$gene==uniques[i])
  originals_summed_with_uniques<-rbind(originals_summed_with_uniques,originals_combined[temp,])
  }



matched_combined<-rbind(brunello[brunello$pam=='Matched',],gecko[gecko$pam=='Matched',])
matched_combined<-matched_combined[order(matched_combined$gene),]
matched_summed<-setNames(data.frame(matrix(ncol = 5, nrow = 0)), colnames(matched_combined))
for(i in 1:nrow(matched_combined)){ 
  progress(i, nrow(matched_combined))
  if((i+1) < nrow(matched_combined) & matched_combined$gene[i] == matched_combined$gene[i+1]){ 
    temp<-matched_combined[i,]
    temp$freq<- matched_combined$freq[i] + matched_combined$freq[i+1]
    matched_summed<-rbind(matched_summed,temp)
  }
}

matched_summed_with_uniques<-matched_summed
for(i in 1:length(uniques)){ 
  progress(i,nrow(length(uniques)))
  temp<-which(matched_combined$gene==uniques[i])
  matched_summed_with_uniques<-rbind(matched_summed_with_uniques,matched_combined[temp,])
}




pam_combined<-rbind(brunello[brunello$pam=='Matched + PAM',],gecko[gecko$pam=='Matched + PAM',])
pam_combined<-pam_combined[order(pam_combined$gene),]
pam_summed<-setNames(data.frame(matrix(ncol = 5, nrow = 0)), colnames(pam_combined))
for(i in 1:nrow(pam_combined)){ 
  progress(i, nrow(pam_combined))
  if((i+1) < nrow(pam_combined) & pam_combined$gene[i] == pam_combined$gene[i+1]){ 
    temp<-pam_combined[i,]
    temp$freq<- pam_combined$freq[i] + pam_combined$freq[i+1]
    pam_summed<-rbind(pam_summed,temp)
  }
}

pam_summed_with_uniques<-pam_summed
for(i in 1:length(uniques)){ 
  progress(i,nrow(length(uniques)))
  temp<-which(pam_combined$gene==uniques[i])
  pam_summed_with_uniques<-rbind(pam_summed_with_uniques,pam_combined[temp,])
}

gecko_brunello_combined<-rbind(pam_summed_with_uniques,matched_summed_with_uniques,originals_summed_with_uniques)


brunello_gecko_combined<-ggplot(gecko_brunello_combined, aes( x = pam, y = 1)) + 
  geom_bar(stat = "identity", aes(fill = as.factor(freq))) + 
  theme_classic() + 
  theme(legend.title = element_blank()) + 
  theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
  scale_fill_brewer(palette="Paired") +
  xlab(NULL) + 
  ylab('Counts')
brunello_gecko_combined
ggsave( 'brunello_geckohuman_combined.pdf', plot = brunello_gecko_combined, height=  4, width = 4)


#changing y axis to have percentage 

gecko_brunello_percent<-gecko_brunello_combined
#gecko_brunello_percent$percent<-


brunello_gecko_combined<-ggplot(gecko_brunello_combined, mapping = aes(x = pam, fill = as.factor(freq))) + 
  geom_bar(position = "fill") + 
  scale_y_continuous(labels = scales::percent) + 
  #scale_y_continuous(labels = scales::percent_format()) + 
  theme_classic() + 
  theme(legend.title = element_blank()) + 
  #scale_y_continuous(labels = percent) + 
  theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
  scale_fill_brewer(palette="Paired") +
  xlab(NULL) + 
  ylab('Percentage')
brunello_gecko_combined

gecko_brunello_combined_renamed<-gecko_brunello_combined
arefactors<- sapply(gecko_brunello_combined_renamed, is.factor)
gecko_brunello_combined_renamed[arefactors] <- lapply(gecko_brunello_combined_renamed[arefactors], as.character)

for(i in 1:nrow(gecko_brunello_combined)){ 
  progress(i)
  if(gecko_brunello_combined_renamed$pam[i]=='Matched'){ 
    gecko_brunello_combined_renamed$pam[i]<-('sgRNA match')
  }
  if(gecko_brunello_combined$pam[i]=='Matched + PAM'){ 
    gecko_brunello_combined_renamed$pam[i]<-('sgRNA +PAM match')
    }
}


gecko_brunello_combined_renamed$pam<-factor(gecko_brunello_combined_renamed$pam, levels = c('Original', "sgRNA match", 'sgRNA +PAM match'))

brunello_gecko_combined<-ggplot(gecko_brunello_combined_renamed, mapping = aes(x = pam, fill = factor(freq))) + 
  geom_bar(position = "fill") + 
  #geom_text(aes(label = count), position = position_fill(vjust = 0.5)) +
  scale_y_continuous(labels = scales::percent) + 
  #scale_y_continuous(labels = scales::percent_format()) + 
  theme_classic() + 
  theme(legend.title = element_blank()) + 
  #scale_y_continuous(labels = percent) + 
  theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
  scale_fill_brewer(palette="Paired") +
  xlab(NULL) + 
  ylab('Percentage')
brunello_gecko_combined


summary_table<-data.frame(t(data.frame(table(originals_combined$freq[originals_combined$freq < 9]))))
summary_table<-rbind(summary_table,t(data.frame(table(originals_combined$freq))[2]))
summary_table<-data.frame(rbind(summary_table,t(data.frame(table(pam_combined$freq))[2])))
rownames(summary_table)<-c('matches','original','matched','matched with pam')
