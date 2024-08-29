pod5Channel=channel.fromPath('/home/ryan/00_nCATS_Pipeline/00_RawData_POD5/pod5_sampleSheet.txt')
pod5Files = pod5Channel.splitCsv().map{'/home/ryan/00_nCATS_Pipeline/00_RawData_POD5/'+it[0]}

process basecalling_POD5toFastQ {
input: path(pod5File)
output: path("${pod5File.name}.sam")  
publishDir 'dorado_SAMs'
cpus 2
script:
"""
~/00_nCATS_Pipeline/dorado-0.7.3-linux-x64/bin/dorado basecaller fast -x cpu $pod5File>${pod5File.name}'.sam'

"""
}

process bam2fq {
input: path(baseCalled)
output: path("${baseCalled.name}.fastq")
publishDir 'dorado_FQs'
script: 
"""
samtools bam2fq -b $baseCalled>${baseCalled.name}'.fastq'
"""
}

process minimapFQ_ONT {
input: path(bcFQ)
output: path("${bcFQ.name}.sam")
publishDir 'minimap_SAMs'
script:
"""
minimap2 -ax map-ont GRCh38.fa $bcFQ>${bcFQ.name}'.sam' 

"""
}

process samOps {
input: path(minimapSAM)
output: path("${minimapSAM}.bam")
publishDir 'aligned_BAMs'
script:
"""
samtools view -bS $minimapSAM>${minimapSAM.name}'.bam'
samtools sort - >'sorted_'${minimapSAM.name}'.bam' &&
samtools index 'sorted_'${minimapSAM.name}'.bam'
"""
}


workflow {
basecalling_POD5toFastQ(pod5Files)
basecalling_POD5toFastQ.out.view()

bam2fq(basecalling_POD5toFastQ.out)
bam2fq.out.view()

minimapFQ_ONT(bam2fq.out)
minimapFQ_ONT.out.view()

samOps(minimapFQ_ONT.out)
samOps.out.view()
}

