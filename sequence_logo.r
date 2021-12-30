# ********** Start of header **************
# Title: calculate codon bias 
#
# Short script is given an input csv file which has a column for each dataset. 0 denotes sequences which were not predicted.
# Script checks the abundance of each nt in each position for each column and generates a score in bits. 
# This is then output into a table showing the bias toward a particular nt in each position.
#
# Author: Alex Pocock  (email address)
# Date: 03/01/20
#
# *********** End of header ****************

# Two common commands at the start of an R script are:
rm(list=ls())         # Clear R's memory

setwd('~/Desktop/PhD_thesis/Chapter4/R_logo') # Set the working directory 

# ******************************************

require(ggplot2)
require(ggseqlogo)

data1 = read.table('data/sequences_upregulated.csv', header=TRUE, sep=',')

vector1 <- c()
for (i in data[,1]) {
  if (nchar(i) == 21) {
    vector1 <- c(vector1, i)
  }
}
ggplot() + geom_logo(vector1)


value[["name4"]] <- c(value[["name4"]],"ACG")

list_21 = list()
list_24 = list()
list_18 = list()

for (i in colnames(data1)) {
  for (a in data1[,i]) {
    if (nchar(a) == 1) {
      list_21[[i]] <- c(list_21[[i]],a)
    }
    else if (nchar(a) == 24) {
      list_24[[i]] <- c(list_24[[i]],a)
    }
  }
}
ggseqlogo(list_21,ncol=2)
ggseqlogo(list_24,ncol=2)

