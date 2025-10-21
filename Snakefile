configfile: "config.yaml"

rule all:
    input:
        expand("results/{sample}.summary.txt", sample=config["samples"])

rule clean:
    input:
        "data/{sample}.txt"
    output:
        temp("results/{sample}.clean.txt")
    resources:
        mem_mb=2000,     # 2GB
        cpus_per_task=1
    shell:
        """
        sort {input} | uniq > {output}
        """

rule summarize:
    input:
        "results/{sample}.clean.txt"
    output:
        "results/{sample}.summary.txt"
    resources:
        mem_mb=1000
    shell:
        """
        wc -l {input} >> {output}
        """

