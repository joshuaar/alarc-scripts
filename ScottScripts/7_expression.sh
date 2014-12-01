RSEMHOME='/data1/utils/rsem-1.2.5'

cd ..
mkdir 7_Expression
cd 7_Expression
ln -s ../6_Assembly/Trinity.fasta.transdecoder.cds .


echo "preparing reference from predicted coding sequences..."
$RSEMHOME/rsem-prepare-reference Trinity.fasta.transdecoder.cds trinity-rsem
echo "done preparing reference"

echo "mapping reads to reference"
for i in `ls ../RawData/ | awk -F "." '{print $1}' | sort | uniq`
do
	echo $i*R1*fastq
	echo $i*R2*fastq
	$RSEMHOME/rsem-calculate-expression --paired-end ../RawData/$i.R1.fastq ../RawData/$i.R2.fastq trinity-rsem $i 
 
done
echo "done mapping reads to reference"

echo "making expression table"
make-expression-table.py
echo "done making expression table"


