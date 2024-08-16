
fastq_directory=$1
output_directory=$2
ref=$3

cd ~

cd 00_nCATS_Pipeline/$fastq_directory
fileNum=$(ls -l | grep '^-' | wc -l)
echo 'FastQ File Num: '$fileNum
ls *.fastq > fastq_sampleSheet.txt


cd ..
mkdir -p $output_directory/minimap_SAMs/
for eachFile in $(cat $fastq_directory'fastq_sampleSheet.txt')
do 
name=${eachFile/.*}
echo 'Mapping Sample: '$eachFile
minimap2 -ax map-ont $ref $fastq_directory$eachFile > $output_directory'minimap_SAMs/'$name'.sam'
done
echo 'Finished Mapping'



