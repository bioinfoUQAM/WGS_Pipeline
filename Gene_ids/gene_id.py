"""
Author : Nicolas de Montigny
Description : This script takes two files in parameters and searches the sequences from the first in the second to get the gene ids, names & positions
Usage : gene_id.py annotated_variants.vcf.gz reference.gtf out.tsv
"""
from gtfparse import read_gtf
import vcf, sys, os

listGenesIDAnnotated = []
tmpList = []

vcfInput=sys.argv[1]
gtf=sys.argv[2]
out=sys.argv[3]

gtf = read_gtf(gtf)
gtfGene = gtf[gtf["feature"] == "gene"]

inputVcf = vcf.Reader(open(vcfInput, 'r'))
for record in inputVcf:
    tmpList = []
    chr = record.CHROM
    pos = record.POS
    gtfGeneChr = gtfGene[gtfGene["seqname"] == chr]
    gtfGeneChrPos = gtfGeneChr[gtfGeneChr["start"] <= pos]
    if len(gtfGeneChrPos.index) > 1:
        gtfGeneChrPos = gtfGeneChrPos[gtfGeneChrPos["end"] >= (pos+len(record.REF))]
        if len(gtfGeneChrPos.index) != 0:
            for i in range(0, len(gtfGeneChrPos.index)):
                tmpList = []
                gene = gtfGeneChrPos['gene']
                geneID = gtfGeneChrPos['db_xref']
                tmpList.append(gene[0])#Gene name
                tmpList.append(pos)#position
                tmpList.append(geneID[0])#GeneID
                listGenesIDAnnotated.append(tmpList)
    elif len(gtfGeneChrPos.index) == 1:
        gene = gtfGeneChrPos['gene']
        geneID = gtfGeneChrPos['db_xref']
        tmpList.append(gene[0])#Gene name
        tmpList.append(pos)#position
        tmpList.append(geneID[0])#GeneID
        listGenesIDAnnotated.append(tmpList)

output = open(out, 'w')
output.write("Gene_name\tPosition\tGene_ID\n")
for i in range(0, len(listGenesIDAnnotated)):
    line = listGenesIDAnnotated[i][0] + "\t" + str(listGenesIDAnnotated[i][1]) + "\t" + listGenesIDAnnotated[i][2] + "\n"
    output.write(line)

output.close()
