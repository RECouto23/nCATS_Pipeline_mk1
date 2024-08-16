sam_directory=$1
output_directory=$2
cd ~


cd 00_nCATS_Pipeline/$sam_directory
fileNum=$(ls -l | grep '^-' | wc -l)
echo 'SAM File Num: '$fileNum
ls *.sam > sam_sampleSheet.txt




cd ~/00_nCATS_Pipeline

for eachFile in $(cat $sam_directory'sam_sampleSheet.txt')
do
name=${eachFile/.*}
samtools view -bS $sam_directory$eachFile > $output_directory$name'.bam'
done 
echo 'SAM --> BAM Complete'

for eachFile in $(cat $sam_directory'sam_sampleSheet.txt')
do
name=${eachFile/.*}
samtools sort -  > $name'_sorted.bam' &&
samtools index $name'_sorted.bam'
echo 'done'
done



