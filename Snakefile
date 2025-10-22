import glob, os

SAMPLES = [os.path.basename(f).replace(".fna", "") for f in glob.glob("data/test/*.fna")]

configfile: "config.yaml"

localrules: count_hops, summarize_hop_counts

rule all:
    input:
        "results/prokka_summary.tsv"


rule prokka:
    input:
        "data/test/{sample}.fna"
    output:
        "results/prokka/{sample}/{sample}.tsv"
    params:
        outdir="results/prokka/{sample}",
        prefix="{sample}"
    conda:
        "envs/prokka.yml"
    shell:
        """
        prokka --force --outdir {params.outdir} --prefix {params.prefix} {input}
        """

rule count_hops:
    input:
        "results/prokka/{sample}/{sample}.tsv"
    output:
        "results/prokka/{sample}/hop_count.txt"
    shell:
        """
        grep -c 'Hop' {input} > {output} || echo 0 > {output}
        """

rule summarize_hop_counts:
    input:
        expand("results/prokka/{sample}/hop_count.txt", sample=SAMPLES)
    output:
        "results/prokka_summary.tsv"
    shell:
        """
        echo -e "sample\thop_count" > {output}
        for f in {input}; do
            s=$(basename $(dirname "$f"))
            c=$(cat "$f")
            echo -e "$s\t$c" >> {output}
        done
        """
