library(Rsamtools)
library(Biostrings)
library(svMisc)


setwd('/Users/gerbix/Documents/vikas/gecko_green_monkey/gecko_mouse')

#gecko_b<-scanBam('/Users/gerbix/Documents/vikas/gecko_green_monkey/gecko_b_20m.bam')
gecko_b<-scanBam('/Users/gerbix/Documents/vikas/gecko_green_monkey/gecko_mouse/mouse_b_20m.bam')

fasta_list<-list.files('/Users/gerbix/Documents/vikas/gecko_green_monkey/green_monkey_fastas', pattern = '*.fa$', full.names = TRUE)

dna = readDNAStringSet("/Users/gerbix/Documents/vikas/gecko_green_monkey/green_monkey_combined.fasta")

dna_names<-c()
for(i in 1:length(names(dna))){ 
  dna_names<-append(dna_names, strsplit(names(dna)[i], ' ')[[1]][1])
}

with_pam_names<-c()
with_pam_seq<-c()
with_pam_names_rc<-c()
with_pam_seq_rc<-c()
without_pam_seq<-c()
without_pam_name<-c()
for (i in 1:length(gecko_b[[1]]$rname)){ 
  progress(i,4170)
  temp<-which( dna_names == gecko_b[[1]]$rname[i])
  #temp_dna_seq is the dna string from the reference
  temp_dna_seq<-as.character(substr(dna[temp,], gecko_b[[1]]$pos[i], (gecko_b[[1]]$pos[i] + 22)))
  #revcomp is the reverse complement dna string from the reference
  revcomp<-as.character(as.character(substr(dna[temp,], gecko_b[[1]]$pos[i] -3 , (gecko_b[[1]]$pos[i] + 20))))
  # print(temp_dna_seq)
  #  print((revcomp))
  # 
  # temp_a<-paste0(gecko_b[[1]]$seq[i], 'AGG')
  # temp_c<-paste0(gecko_b[[1]]$seq[i], 'CGG')
  # temp_t<-paste0(gecko_b[[1]]$seq[i], 'TGG')
  # temp_g<-paste0(gecko_b[[1]]$seq[i], 'GGG')
  # 
  temp_nuc<-paste0(gecko_b[[1]]$seq[i], '.GG')
  # temp_a_rev<-paste0('CCT',gecko_b[[1]]$seq[i])
  # temp_c_rev<-paste0('CCG',gecko_b[[1]]$seq[i])
  # temp_t_rev<-paste0('CCC',gecko_b[[1]]$seq[i])
  # temp_g_rev<-paste0('CCA',gecko_b[[1]]$seq[i])
  temp_nuc_rev<-paste0('CC.',gecko_b[[1]]$seq[i])
  
  #if(grepl(temp_a,temp_dna_seq) |grepl(temp_c,temp_dna_seq) | grepl(temp_t,temp_dna_seq) | grepl(temp_g,temp_dna_seq)){ 
  if(grepl(temp_nuc,temp_dna_seq)){
    #print('ok')
    with_pam_names<-append(with_pam_names, gecko_b[[1]]$qname[i])
    with_pam_seq<-append(with_pam_seq, temp_dna_seq)
  }
  if(grepl(temp_nuc_rev,revcomp)){ 
    #print('rc')
    with_pam_names<-append(with_pam_names, gecko_b[[1]]$qname[i])
    with_pam_seq<-append(with_pam_seq, temp_dna_seq)
  }
  else{ 
    without_pam_name<-append(without_pam_name, gecko_b[[1]]$qname[i])
    without_pam_seq<-append(without_pam_seq, temp_dna_seq)
  }
}

with_pam<-data.frame(with_pam_names,with_pam_seq)
withoutpam<-data.frame(without_pam_name, without_pam_seq)

write.csv(with_pam,'gecko_mouse_b_with_pam_test.csv')
write.csv(withoutpam, 'gecko_mouse_b_without_pam_test.csv')

