#!/usr/bin/env bash
set -euo pipefail

# --- Usage check ---
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <sample_list.txt> <output_dir>"
    echo "Example: $0 samplelist.txt test"
    exit 1
fi

SAMPLELIST=$1
OUTDIR=$2

mkdir -p data/${OUTDIR}

# Dowload genomes using ncbi-datasets
datasets download genome accession \
	--inputfile ${SAMPLELIST} \
	--dehydrated \
	--filename data/${OUTDIR}.zip

unzip data/${OUTDIR}.zip -d data/${OUTDIR}
datasets rehydrate --directory data/${OUTDIR}
rm data/${OUTDIR}.zip

# Flatten directory structure into test folder
find data/${OUTDIR}/ncbi_dataset/data -type f -name "*.fna" | while read genome; do
	sample=$(basename $(dirname "$genome"))
	cp $genome data/${OUTDIR}/${sample}.fna
done

# Cleanup original ncbi-datasets filestructure
rm data/${OUTDIR}/README.md
rm data/${OUTDIR}/md5sum.txt
rm -r data/${OUTDIR}/ncbi_dataset
