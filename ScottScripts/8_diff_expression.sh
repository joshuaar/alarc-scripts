#!/bin/bash
cd ..
mkdir 8_Diff_Expression
cd 8_Diff_Expression
ln -s ../7_Expression/all.genes.results.csv .
if [ -e ../7_Expression/groups.txt ]
then
	echo "groups.txt found, proceeding with differential expression"
	ln -s ../7_Expression/groups.txt .
	diff-expression.r all.genes.results.csv groups.txt
	echo "differential expression analysis completed"
else
	echo "groups.txt not found, please format groups.txt in 7_Expression folder"
fi
