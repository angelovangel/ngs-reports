#! /usr/local/bin/bash
# produce a SAF table (for Rsubread) from a prokka-generated gff

GFFIN=$1

echo -e "GeneID\tChr\tStart\tEnd\tStrand\tgene_biotype\tproduct"
cat $GFFIN | \
gsed '/\tCDS\t/ s/$/;gene_biotype=protein coding/' | \
gsed '/\trRNA\t/ s/$/;gene_biotype=rRNA/' | \
gsed '/\ttRNA\t/ s/$/;gene_biotype=tRNA/' | \
gsed '/\ttmRNA\t/ s/$/;gene_biotype=tmRNA/' | \
gffread --table ID,@chr,@start,@end,@strand,gene_biotype,product
# TODO output a log file with numbers of biotypes

#gffread --table ID,@chr,@start,@end,@strand testdata/prokka-ID40/PROKKA_10132019.gff
