cd /data1/seqDBs
update_blastdb nr
for i in `ls nr*.tar.gz`
do
tar -zxvf $i
done
