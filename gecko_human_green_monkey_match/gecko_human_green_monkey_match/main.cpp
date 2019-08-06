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

int main(int argc, const char * argv[]) {
    ifstream green_monkey_fasta;
    green_monkey_fasta.open ("/Users/gerbix/Documents/vikas/gecko_green_monkey/green_monkey_n_removed.fasta");
    
    ifstream gRNAs;
    gRNAs.open("/Users/gerbix/Documents/vikas/gecko_green_monkey/geck_20m_sequences_combined.fasta");
    
    cout << ;
    return 0;
}
