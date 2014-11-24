# This command uses transdecoder to output transcripts.
# It creates several outputs of the form Trinity.fasta.transdecoder...
# Trinity.fasta.transdecoder.pep is the one with peptide sequences
# Trinity.fasta.transdecoder.cds is the one with nucleotide sequences
# The first and only argument to this script should be the 
# FASTA file created by Trinity
TransDecoder -t $1
