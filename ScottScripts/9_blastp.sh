cd ..
mkdir 9_BLASTP
cd 9_BLASTP
ln -s ../6_Assembly/Trinity.fasta.transdecoder.pep .
echo "starting blastp on nr database"
blastp.sh Trinity.fasta.transdecoder.pep
echo "blastp completed"
