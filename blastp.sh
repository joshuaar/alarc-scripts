blastp -query $1 -db /data1/seqDBs/nr -num_threads 64 -max_target_seqs 10 -outfmt 5 -out $1.BLASTP-nr.xml
