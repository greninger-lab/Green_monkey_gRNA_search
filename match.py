# Python program for KMP Algorithm 

green_monkey_fasta=open("/Users/gerbix/Documents/vikas/gecko_green_monkey/green_monkey_n_removed.fasta", "r")
seq20m=open("/Users/gerbix/Documents/vikas/gecko_green_monkey/geck_20m_sequences_combined.fasta", "r")

green_monkey_fasta = green_monkey_fasta.read()
print('finished reading')
seqs=seq20m.readlines()



def KMPSearch(pat, txt): 
    M = len(pat) 
    N = len(txt) 
  

    lps = [0]*M 
    j = 0 
    computeLPSArray(pat, M, lps) 
  
    i = 0 
    while i < N: 
        if pat[j] == txt[i]: 
            i += 1
            j += 1
  
        if j == M: 
            print ("Found pattern at index" + str(i-j) )
            j = lps[j-1] 
            return True
  
        elif i < N and pat[j] != txt[i]: 

            if j != 0: 
                j = lps[j-1] 
            else: 
                i += 1
  
def computeLPSArray(pat, M, lps): 
    len = 0 
    lps[0] 
    i = 1
  
    while i < M: 
        if pat[i]== pat[len]: 
            len += 1
            lps[i] = len
            i += 1
        else: 

            if len != 0: 
                len = lps[len-1] 
  
            else: 
                lps[i] = 0
                i += 1

for x in seqs:
    base_seq=(x.split()[1])
    #print(base_seq)
    A_seq = base_seq + 'AGG'
    C_seq = base_seq + 'CGG'
    T_seq = base_seq + 'TGG'
    G_seq = base_seq + 'GGG'
    PAM_seqs=[A_seq,C_seq,T_seq,G_seq]

    # for i in range(len(PAM_seqs)): 
    #     print(i)
    #     if(PAM_seqs[i] in green_monkey_fasta): 
    #         print(i)
    #         print('\n')
    for i in range(len(PAM_seqs)): 
        print(i)
        if (KMPSearch(PAM_seqs[i], green_monkey_fasta)): 
            print(PAM_seqs[i])











