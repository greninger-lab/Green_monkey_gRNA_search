# Looking for GeCKO human gRNAs in the Green monkey genome

# #Designing a novel Green monkey gRNA library is expensive, but an existing Human one may do the trick
The GeCKO v2 DNA plasmid library consists of over 100,000 gRNAs for to knock out each gene in the Human/Mouse genome. VERO cells 
are a popular Green monkey kidney epitheleal cell line for research with no similar gRNA library. Since the Human and Green 
Monkey genomes are fairly similar, we believe there will be many shared gRNA targets between the two.

## Overview of code logic 
The Green monkey genome (https://uswest.ensembl.org/Chlorocebus_sabaeus/Info/Annotation) was downloaded and combined into one 
fasta file. Bowtie2 indexes were not availabe online so we had to build them. Alignments from the GeCKO V2 library were done to
the Green monkey reference genome and filtered for any gRNAs with 20 (whole sequence) exact matches. In the match Rscript, PAM 
sequnces ```-NGG, CCN-``` were appended to either end of each read and grepped from the position of match in the BAM file to 
the reference genome. The figure below shows the number of exact matches for each of the following: Original GeCKO library, 
20 exact matches to Green monkey, and 20 exact matches to Green monkey with a PAM sequence. 
