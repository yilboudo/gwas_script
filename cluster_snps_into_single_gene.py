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

if len(sys.argv) < 4:
    print usage
    exit(1)


f1 = open(sys.argv[1], 'r')
f2 = open(sys.argv[2], 'w')
gs = sys.argv[3]
snp = sys.argv[4]


def cluster(file1,file2, gene_symbol, variants):
    header = next(file1)
    colunmnames = header.strip('\n').split("\t")
    print colunmnames

    clusters = {}
    for line in file1:
        sep = line.index('\t')
        head = line.strip('\n').split('\t')[colunmnames.index(gene_symbol)]
        tail = line.strip('\n').split('\t')[colunmnames.index(variants)] 
        if head in clusters:
            clusters[head] +=  " "+"\t"+ tail
        else:
            clusters[head] = tail
    file2.write( "".join(([head + " " + tail+'\n' for head, tail in clusters.iteritems()])))
    file2.close()


cluster(f1,f2, gs,snp)




