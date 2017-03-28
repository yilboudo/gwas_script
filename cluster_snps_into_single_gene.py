#!/usr/bin/env python
import sys, os,re
"""
A script to cluster variants into a single gene based on
a separator (tab, or space)

Takes two arguments:
    1) The input file with each variants mapping to a gene
    2) The ouput file name which will contain all genes with variants clustered 
    3) Header name for gene symbol
    4) Header name for snp
"""

usage = """cluster_snps_into_single_gene - collapses SNPs mapping to the same gene.

Usage:
cluster_snps_into_single_gene.py [INPUT_FILE] [OUTPUT_FILE] [GENE_NAME_HEADER] [SNP_NAME_HEADER]

clusters snps mapping to same gene."""

#Check four arguments are provided
if len(sys.argv) < 4:
    print usage
    exit(1)

#Check that a readable file is provided
try:
    open(sys.argv[1], 'r')
except IOError:
    print "Error: " + sys.argv[1] + " does not exist, or is not readable!"
    exit(1)

#input file
f1 = open(sys.argv[1], 'r')


#Check that a readable file is provided
try:
    str(sys.argv[2])
except IOError:
    print "Error: " + sys.argv[2] + " does not exist, or is not readable!"
    exit(1)

#Define to output file
f2 = open(sys.argv[2], 'w')

#Check that gene symbol header name is a string
try:
    str(sys.argv[3])
    
except ValueError:
    print "Error: string  is needed!"
    exit(1)

#Define gene symbol header name
gs = sys.argv[3]


#Check that snp header name is a string
try:
    str(sys.argv[4]) 
except ValueError:
    print "Error: string  is needed!"
    exit(1)

#Define snp header name
snp = sys.argv[4]


def cluster(file1,file2, gene_symbol, variants):
    header = next(file1)
    colunmnames = header.strip('\n').split("\t")
    #Make sure entered columnname is present
    try:
        colunmnames.index(gene_symbol)
    except ValueError:
        print "Error: Columname is absent. Check your Spelling!"
        exit(1)
    #Make sure entered columnname is present
    try:
        colunmnames.index(variants)    
    except ValueError:
        print "Error: Columname is absent. Check your Spelling!"
        exit(1)
    
    clusters = {}
    for line in file1:
        sep = line.index('\t')
        head = line.strip('\n').split('\t')[colunmnames.index(gene_symbol)]
        tail = line.strip('\n').split('\t')[colunmnames.index(variants)] 
        if head in clusters:
            clusters[head] +=  "\t"+"\t"+ tail
        else:
            clusters[head] = tail
    file2.write( "".join(([head + "\t" + tail+'\n' for head, tail in clusters.iteritems()])))
    file2.close()


cluster(f1,f2, gs,snp)




