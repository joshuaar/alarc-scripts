
1. Copy files from original locations to one folder

    1-grab-copy.sh fastq.gz RawData

The above copies all fastq.gz files from the subdirectories within the current directory to a folder called RawData

1.1. Change directories to the newly created one with all the fastq files

    cd RawData

2. Extract the gzipped archives to form Right and Left read libraries for each sample. Arguments MUST be in quotes.

    2-extract.sh "27A*R1*fastq.gz" "27A*R2*fastq.gz"

2.1. Change directories to the newly created "extracted" directory with the
unzipped fastq files.

    cd extracted

3. Concatinate Right and Left libraries to create a master set of reads for
assembly. Files must contain R1 or R2 in the name.

    3-concatinate.sh

4. FASTQC on reads (optional). You can run FASTQC on the reads to make sure
nothing weird is happening. The following puts results in a folder called
raw-fastqc

    4-fastqc.sh raw-fastqc

5. Assembly with trinity. This makes a folder called trinity_out_dir with the
assembly file in it.

    5-assemble.sh all.R1.fastq all.R2.fastq 

6. Transdecoder
go into trinity_out_dir. If Trinity was successful there should be a file
called Trinity.fasta. This is the assembled transcripts. Run the following:

    6-transdecoder.sh Trinity.fasta

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

    7-make-expression-table.sh

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

    8-diff-expression.r all.results.fpkm.csv groups.txt

If successful, this will create a new file diff_expression.csv in the current
directory.

8. Blast
Several BLAST programs are installed for use. Here is an example of using
BLASTP to search the NR database:

    blastp -query Trinity.fasta.transdecoder.pep -db /data1/seqDBs/nr -num_threads 64
-max_target_seqs 1 -outfmt 5 -out Trinity.fasta.transdecoder.pep.BLASTP-nr.xml

Alternatively, run the script which does the same thing:

    9-blastp.sh Trinity.fasta.transdecoder.pep

9. Make Table
Now we have assembled transcripts, BLAST results, and a differential
expression analysis. We can put these all together in a single table as
follows:

    10-make-annotation-table.py -e $expression-table -b $BLAST-xml -d
$diff-expression-p-values

Example:

    10-make-annotation-table.py -e expression/all.genes.results.csv -b
Trinity.fasta.transdecoder.pep.blastp.nr.xml -d expression/diff_expression.csv
> annotation_table.csv

9.1 Search Table

10. InterProScan Annotation


    
