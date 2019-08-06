import pysam
from Bio import SeqIO


gecko_a = pysam.AlignmentFile("/Users/gerbix/Documents/vikas/gecko_green_monkey/gecko_a_20m.sam", "r")
gecko_a = pysam.AlignmentFile("/Users/gerbix/Documents/vikas/gecko_green_monkey/gecko_b_20m.sam", "r")

# for read in gecko_a: 
# 	print(read.get_reference_name())


for read in gecko_a:
	#if read.reference_id == '20': 
	print(str(read.rname) + ' ' +str(read.qname))