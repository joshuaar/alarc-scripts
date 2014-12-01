mkdir ../2_FilterRawData
cd ../2_FilterRawData
cp ../Scripts/trimmomatic-0.32.jar . 
cp ../Scripts/TruSeq3-PE.fa . 
for x in `ls ../RawData | awk -F "." '{print $1}'|sort|uniq` 
do 
echo $x
java -jar trimmomatic-0.32.jar PE -threads 64 -phred33 ../RawData/$x.R1.fastq ../RawData/$x.R2.fastq $x.trimmed.R1.fastq $x.single.R1.fastq $x.trimmed.R2.fastq $x.single.R2.fastq ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:10 TRAILING:20 SLIDINGWINDOW:4:25 MINLEN:36 
done
mkdir Single 
mv *single* Single/
rm trimmomatic-0.32.jar 
rm TruSeq3-PE.fa 

