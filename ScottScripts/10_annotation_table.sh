cd ..
mkdir 10_Annotation
cd 10_Annotation
ln -s ../7_Expression/all.genes.results.csv .
ln -s ../9_BLASTP/*.xml .
ln -s ../8_Diff_Expression/diff_expression.csv .

make-annotation-table.py -e all.genes.results.csv -b *.xml -d diff_expression.csv > annotation_table.csv
