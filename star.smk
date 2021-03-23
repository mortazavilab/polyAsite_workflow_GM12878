from pathlib import Path

configfile:
    "config.yaml"


samples = [
    'GM12878rep1',
    'GM12878rep2'
]


samples_dir = Path(config["samples_dir"])


rule all:
    input:
        expand(str(samples_dir / '{sample}' /
                   config['genome'] / 'Aligned.sortedByCoord.out.bam'),
               sample=samples)


rule star_index:
    input:
        fasta = config['genome_fasta_raw'],
        gtf = config['gene_annotation']
    output:
        directory(config['star_index'])
    threads: 8
    log:
        "logs/star_index_GRCh38_release99.log"
    wrapper:
        "0.72.0/bio/star/index"


rule star_align:
    input:
        fq1 = str(samples_dir / '{sample}' /
                  config['genome'] / '{sample}.trimmed.polyA_filtered.fastq.gz')
    output:
        bam = samples_dir / '{sample}' / \
            config['genome'] / 'Aligned.sortedByCoord.out.bam'
    log:
        "logs/star/{sample}.log"
    params:
        index = config['star_index'],
        extra = "--outSAMtype BAM SortedByCoordinate --limitBAMsortRAM 32000000000 --outSAMattributes All"
    threads: 8
    wrapper:
        "0.72.0/bio/star/align"
