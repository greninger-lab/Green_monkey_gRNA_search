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

struct suffix
{
    int index;
    char *suff;
};
int cmp(struct suffix a, struct suffix b)
{
    return strcmp(a.suff, b.suff) < 0? 1 : 0;
}


int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
