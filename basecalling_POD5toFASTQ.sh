pod5_directory=$1
fastq_directory=$2
model=$3

cd $pod5_directory
ls *.pod5 > pod5_sampleSheet.txt
cd ..

for eachFile in $(cat $pod5_directory/pod5_sampleSheet.txt)
do

name=${eachFile/.*}
#echo $name
echo 00_nCATS_Pipeline/$pod5_directory$name".pod5"
cd ~
~/00_nCATS_Pipeline/dorado-0.7.3-linux-x64/bin/dorado basecaller $model -x cpu "00_nCATS_Pipeline/"$pod5_directory$name".pod5">"00_nCATS_Pipeline/"$fastq_directory"SAM/"$name'.sam'
done


cd 00_nCATS_Pipeline/$fastq_directory"SAM/"
ls *.sam > sam_sampleSheet.txt
cd ~/00_nCATS_Pipeline/

for eachFile in $(cat $fastq_directory"SAM/sam_sampleSheet.txt")
do
name=${eachFile/.*}
echo $fastq_directory"SAM/"$name".sam converting to BAM"
samtools bam2fq $fastq_directory"SAM/"$eachFile > $fastq_directory$name".fastq"
done 

