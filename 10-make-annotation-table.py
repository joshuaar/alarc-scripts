#!/usr/bin/python3.4
import argparse,SearchMyBlast
import sys,os,csv
from lxml import etree
import numpy as np

if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Create an annotation table from expression results, differential expression results, and BLASTP results")
	parser.add_argument("-e", "--expression", help="Expression Table path", required=True)
	parser.add_argument("-b", "--blast", help="BLAST XML path", required=True)
	parser.add_argument("-d", "--diff", help="differential expression p-value table",required=True)
	args = parser.parse_args()
	blastxml = etree.parse(args.blast)
	blast = np.array(SearchMyBlast.returnTopHit(blastxml))
	expression = np.array([i for i in csv.reader(open(args.expression))])
	diff = np.array([i for i in csv.reader(open(args.diff))])
	
	expressionData = expression[:,1:]
	diffData = diff[:,1:]
	#print(blast.shape)
	#print(expressionData.shape)
	#print(diffData.shape)
	if len(set([expressionData.shape[0],diffData.shape[0],blast.shape[0]])) > 1:
		#if arrays are not the same shape
		raise Exception("Input Data must be the same shape. Were these all done on the same FASTA file?"
)
	for i,v in enumerate(expressionData):
		print(",".join([str(j) for j in list(blast[i]) + list(expressionData[i]) + list(diffData[i])]))
	
