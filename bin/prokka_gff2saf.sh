#! /usr/local/bin/bash
# use params$GTF_attr_type
# to group features into meta-features
# often it is ID, gene_id, locus_tag...

GFFIN=$1

echo -e "GeneID\tChr\tStart\tEnd\tStrand\tgene_biotype\tproduct"
cat $GFFIN | \
gsed '/\tCDS\t/ s/$/;gene_biotype=protein coding/' | \
gsed '/\trRNA\t/ s/$/;gene_biotype=rRNA/' | \
gsed '/\ttRNA\t/ s/$/;gene_biotype=tRNA/' | \
gsed '/\ttmRNA\t/ s/$/;gene_biotype=tmRNA/' | \
gffread --table ID,@chr,@start,@end,@strand,gene_biotype,product

#gffread --table ID,@chr,@start,@end,@strand testdata/prokka-ID40/PROKKA_10132019.gff
