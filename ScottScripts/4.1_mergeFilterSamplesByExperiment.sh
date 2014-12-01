mkdir ../4_MergeFilterSamplesByExperiment
for x in `ls ../2_FilterRawData | awk -F "_" '{print $1}' | sort | uniq` 
do 
echo $x
cat ../2_FilterRawData/$x*trimmed*R1.fastq >> ../4_MergeFilterSamplesByExperiment/$x.trimmed.R1.fastq
cat ../2_FilterRawData/$x*trimmed*R2.fastq >> ../4_MergeFilterSamplesByExperiment/$x.trimmed.R2.fastq
done
cat ../2_FilterRawData/*trimmed*R1.fastq > ../4_MergeFilterSamplesByExperiment/all.trimmed.R1.fastq
cat ../2_FilterRawData/*trimmed*R2.fastq > ../4_MergeFilterSamplesByExperiment/all.trimmed.R2.fastq

