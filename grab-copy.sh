# Finds files in subdiretories matching a specified file extension
# Moves these files to a destination directory
# Useful for grabbing fastq files from sequencing experiments
# argument $1 is a file extension (*.fastq.gz) and $2 is destination directory
mkdir -p $2
find . -iname "$1" -exec cp {} $2 \;
