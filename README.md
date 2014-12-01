#README FOR PIPELINE USAGE


##Part 1: Create Directories and Copy Data

We start with several directories full of raw data. From this we need to create the following directory structure

    my_parent_dir
        Scripts
        RawData

That is, create a directory with two subdirectories called Scripts and RawData. We will create this directory structure
as follows:

    mkdir my_parent_dir
    cp /data1/scripts/alarc-scripts/ScottScripts my_parent_dir/Scripts

Now you must extract, concatinate and copy data into the RawData folder. There are many ways to do this, but all files
must conform to the following naming convention:

    SAMPLE.R1.fastq
    SAMPLE.R2.fastq

where SAMPLE is a unique name for that sample. Thus there are exactly two files with the prefix SAMPLE.*

Two provided scripts can be used to make this copying process easier. Say you have a folder full of subfolders containing
fastq.gz files like this:

    MyData
        MySample1
            MySample1.XXXY.R1.001.fastq.gz
            MySample1.XXXY.R1.002.fastq.gz
            MySample1.XXXY.R2.001.fastq.gz
            MySample1.XXXY.R2.002.fastq.gz
        MySample2
            MySample2.XXXY.R1.001.fastq.gz
            MySample2.XXXY.R1.002.fastq.gz
            MySample2.XXXY.R2.001.fastq.gz
            MySample2.XXXY.R2.002.fastq.gz

first cd to MyData, then run the following:

    grab-copy.sh "*fastq.gz" CopyData
    cd CopyData
    extract.sh "MySample1*R1*fastq.gz" "MySample1*R2*fastq.gz" "MySample2*R1*fastq.gz" "MySample2*R2*fastq.gz"

This will create a directory called extracted within CopyData that looks as follows:

    CopyData
        extracted
            MySample1.R1.fastq
            MySample1.R2.fastq
            MySample2.R1.fastq
            MySample2.R2.fastq

now simply copy the extracted directory into the RawData folder we need to run the pipeline. From the CopyData directory:
        
    cp -rf extracted my_parent_dir/RawData

where my_parent_dir is the directory created earlier to hold Scripts and RawData. The directory structure is now complete

##Running the Assembly Pipeline

cd into the Scripts directory. It should contain the following scripts:

    1_fastqcRawData.sh
    2_filterRawData.sh
    3_fastqcFilterRawData.sh
    4_mergeFilterSamplesByExperiment.sh
    5_normalizeReads.sh
    6_assembly.sh
    7_expression.sh
    8_diff_expression.sh
    9_blastp.sh
    10_annotation_table.sh

These are ready to run with no arguments for the most part. 
cd into the Scripts directory and run these as follows, one at a time.
Verify that one script has completed before starting the next.

    ./1_fastqcRawData.sh
    ./2_filterRawData.sh
    ./3_fastqcFilterRawData.sh
    ./4_mergeFilterSamplesByExperiment.sh
    ./5_normalizeReads.sh
    ./6_assembly.sh
    ./7_expression.sh

If you are going to start a script then log out, surround your command with nohup (short for no hangup signal)
For example, instead of running:

    ./6_assembly.sh

run this instead:

    nohup ./6_assembly.sh &

This will run the script in the background until completed. You can check the status by viewing nohup.out or
using the top command:

    top

to check on the running processes.

##Running Annotation Pipeline

Once this is done we should have the following directories within my_parent_dir:

    my_parent_dir
        Scripts
        RawData
	1_Fastqc_RawData
        2_FilterRawData
        3_Fastqc_FilterRawData
        4_MergeFilterSamplesByExperiment
        5_NormalizeReads
        6_Assembly
        7_Expression

cd into the 7_Expression folder and create a groups.txt file as follows:

Look at the header for all.genes.results.csv. This has the expression data for each sample.
To print the header to the screen, use the following command:

    head -n1 all.genes.results.csv        

It should look something like this:

ID,27A.genes.results,27Aln1.genes.results,27B.genes.results,27Bln1.genes.results,27C.genes.results,27Cln1.genes.results,39A.genes.results,39Aln1.genes.results,39B.genes.results,39Bln1.genes.results,39C.genes.results,39Cln1.genes.results

Each comma separated value (except for the first one called ID) is a sample. For each sample, we need to assign a group and indicate this with groups.txt. For the above example, there are 6 samples in each group, so the groups.txt file would look like this:

1
1
1
1
1
1
2
2
2
2
2
2

The file should contain nothing but group ids. There should be n lines in the file, where n is the number of samples you are working with.
Be sure to save the groups.txt file to the 7_Expression folder. The nano editor will work well for this:

    nano groups.txt

Now run the rest of the scripts in order, using nohup if necessary:

    ./8_diff_expression.sh
    ./9_blastp.sh
    ./10_annotation_table.sh

This should create corresponding directories. The final annotation table produced by the pipeline can be found in:

    10_Annotation/annotation_table.csv

This contains much information need to identify classes of highly or differentially expressed proteins
This table has the following columns:

ID(short)	[Expression FPKM, 1 column per sample]	ID(long, transcript details)	Top_Hit(top blast hit)	E_Value(E Value for top blast hit)	P_Value(for differential expression)	P_Value_FDR(FDR adjusted P-value for multiple hypotheses)

#README FOR UNIX STYLE SCRIPTS IN THIS DIRECTORY

1. Copy files from original locations to one folder

    grab-copy.sh "*fastq.gz" RawData

The above copies all fastq.gz files from the subdirectories within the current directory to a folder called RawData

.e1. Change directories to the newly created one with all the fastq files

    cd RawData

2. Extract the gzipped archives to form Right and Left read libraries for each sample. Arguments MUST be in quotes.

    extract.sh "27A*R1*fastq.gz" "27A*R2*fastq.gz"

2.1. Change directories to the newly created "extracted" directory with the
unzipped fastq files.

    cd extracted

3. Concatinate Right and Left libraries to create a master set of reads for
assembly. Files must contain R1 or R2 in the name.

    concatinate.sh

4. FASTQC on reads (optional). You can run FASTQC on the reads to make sure
nothing weird is happening. The following puts results in a folder called
raw-fastqc

    fastqc.sh raw-fastqc

5. Assembly with trinity. This makes a folder called trinity_out_dir with the
assembly file in it.

    assemble.sh all.R1.fastq all.R2.fastq 

6. Transdecoder
go into trinity_out_dir. If Trinity was successful there should be a file
called Trinity.fasta. This is the assembled transcripts. Run the following:

    transdecoder.sh Trinity.fasta

This will start Transdecoder and create a new directory with results when done

7. Expression Estimation
Make sure you are in trinity_out_dir
Run the following:
    
    /data1/utils/rsem-1.2.5/rsem-prepare-reference
Trinity.fasta.transdecoder.cds trinity-rsem

Or if you want to use the raw transcripts instead of the ones created by
transdecoder:

    /data1/utils/rsem-1.2.5/rsem-prepare-reference
Trinity.fasta trinity-rsem

The final argument (trinity-rsem) refers to the reference
library created by RSEM. This is a data structure used only by RSEM to map
reads to a "genome" or transcriptome.

Once this is completed, we can start mapping reads. Run the following:

    /data1/utils/rsem-1.2.5/rsem-calculate-expression --paired-end $R1 $R2 trinity-rsem $NAME

This command has three variables which need to be replaced with your specific
data before it is run. $R1 refers to the fastq file path for the upstream reads, and R2 refers to the one for the downstream reads. $NAME should be a specific
name given to the current sample. Example:

    /data1/utils/rsem-1.2.5/rsem-calculate-expression --paired-end ~/fastq/27A.R1.fastq ~/fastq/27A.R2.fastq trinity-rsem 27A

Once this is done for all the samples in the experiment, run the following
command to make an expression table:

    make-expression-table.sh

This will make a file called all.results.fpkm.csv in the current directory

7.1 Differential Expression Estimation
Make a file called groups.txt. This file should have one line per sample, and
indicates the grouping of each sample. So say we had 6 samples and two
treatments (Cold and Hot). The groups.txt file for this experiment would look
like this:

C
C
C
H
H
H

Each line on the groups.txt file corresponds to a column in the expression
table.

Now, to run the differential expression analysis, execute the following
command:

    diff-expression.r all.results.fpkm.csv groups.txt

If successful, this will create a new file diff_expression.csv in the current
directory.

8. Blast
Several BLAST programs are installed for use. Here is an example of using
BLASTP to search the NR database:

    blastp -query Trinity.fasta.transdecoder.pep -db /data1/seqDBs/nr -num_threads 64
-max_target_seqs 1 -outfmt 5 -out Trinity.fasta.transdecoder.pep.BLASTP-nr.xml

Alternatively, run the script which does the same thing:

    blastp.sh Trinity.fasta.transdecoder.pep

9. Make Table
Now we have assembled transcripts, BLAST results, and a differential
expression analysis. We can put these all together in a single table as
follows:

    make-annotation-table.py -e $expression-table -b $BLAST-xml -d
$diff-expression-p-values

Example:

    make-annotation-table.py -e expression/all.genes.results.csv -b
Trinity.fasta.transdecoder.pep.blastp.nr.xml -d expression/diff_expression.csv
> annotation_table.csv

