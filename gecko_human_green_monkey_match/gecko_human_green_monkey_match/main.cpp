//
//  main.cpp
//  gecko_human_green_monkey_match
//
//  Created by Alex Greninger on 8/6/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//
//help from https://www.geeksforgeeks.org/suffix-array-set-1-introduction/
#include <iostream>
#include <cstring>
#include <algorithm>
#include <fstream>
#include <string>
#include <sstream>
#include <iostream>
#include <vector>

using namespace std;

struct suffix
{
    int index;
    char *suff;
};
int cmp(struct suffix a, struct suffix b)
{
    return strcmp(a.suff, b.suff) < 0? 1 : 0;
}

int *buildSuffixArray(char *txt, int n)
{
    // A structure to store suffixes and their indexes
    struct suffix suffixes[n];
    
    // Store suffixes and their indexes in an array of structures.
    // The structure is needed to sort the suffixes alphabatically
    // and maintain their old indexes while sorting
    for (int i = 0; i < n; i++)
    {
        suffixes[i].index = i;
        suffixes[i].suff = (txt+i);
    }
    
    // Sort the suffixes using the comparison function
    // defined above.
    sort(suffixes, suffixes+n, cmp);
    
    // Store indexes of all sorted suffixes in the suffix array
    int *suffixArr = new int[n];
    for (int i = 0; i < n; i++)
        suffixArr[i] = suffixes[i].index;
    
    // Return the suffix array
    return  suffixArr;
}

void printArr(int arr[], int n)
{
    for(int i = 0; i < n; i++)
        cout << arr[i] << " ";
    cout << endl;
}

void search(char *pat, char *txt, int *suffArr, int n)
{
    int m = strlen(pat);  // get length of pattern, needed for strncmp()
    
    // Do simple binary search for the pat in txt using the
    // built suffix array
    int l = 0, r = n-1;  // Initilize left and right indexes
    while (l <= r)
    {
        // See if 'pat' is prefix of middle suffix in suffix array
        int mid = l + (r - l)/2;
        int res = strncmp(pat, txt+suffArr[mid], m);
        
        // If match found at the middle, print it and return
        if (res == 0)
        {
            cout << "\n Pattern found at index " << suffArr[mid];
            cout << "\n" ;
            return;
        }
        
        // Move to left half if pattern is alphabtically less than
        // the mid suffix
        if (res < 0) r = mid - 1;
        
        // Otherwise move to right half
        else l = mid + 1;
    }
    
    // We reach here if return statement in loop is not executed
    cout << "Pattern not found";
}

int main(int argc, const char * argv[]) {
    ifstream green_monkey_fasta;
    //green_monkey_fasta.open ("/Users/gerbix/Documents/vikas/gecko_green_monkey/green_monkey_n_removed.fasta");
    green_monkey_fasta.open ("/Users/gerbix/Documents/vikas/gecko_green_monkey/test/test_n_removed.fasta");
    ifstream gRNA_names;
    gRNA_names.open("/Users/gerbix/Documents/vikas/gecko_green_monkey/gecko_names_all.txt");
    
    ifstream grna_seqs;
    grna_seqs.open("/Users/gerbix/Documents/vikas/gecko_green_monkey/gecko_seqs_all.txt");

    string fastafile;
    cout << "reading";
    getline(green_monkey_fasta, fastafile);
    
    
    
    cout << "\n done";
    
    cout <<"\n creating char array";
    
    char *fasta_char = &fastafile[1];

    /*
    char fasta_char[fastafile.size() + 1];
    fastafile.copy(fasta_char, fastafile.size() + 1);
    fasta_char[fastafile.size()] = '\0';
    */
    
    cout << "\n building suffix array \n";
    int n = strlen(fasta_char);
    int *suffArr = buildSuffixArray(fasta_char, n);
    cout << "suffix array built \n";
    //char *cstr = &str[0];
    
    //cout << "entering while loop \n" ;
    
    cout << strlen(fasta_char);
    char pat[] = "ATTCTTGAACCTCCCAACTA";
    
    search(pat, fasta_char, suffArr, n);
    
    string line;

    /*
    while (getline(grna_seqs, line))
    {
        //cout << line;
        //char line_char;
        //const char *cstr = line.c_str();

        
        // process pair (a,b)
    }
    */
    
    //cout << ;
    return 0;
}
