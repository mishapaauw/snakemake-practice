# snakemake-practice

The current pipeline runs genome annotation tool Prokka on all bacterial genomes found in folder `data/test/`. It then counts the number of genes annotated with 'Hop', type 3 effectors, and  reports the Hop counts for each genome in one summary file. 

## Preparation

Downloading the genomes is not part of the pipeline, but a small script was written to facilitate this. First, get a list of accession numbers (format: `GCA_12334`) in a `.txt` file. Then use the download script as such:

```bash
conda activate ncbi_datasets
bash scripts/download_genomes.sh samplelist.txt test
```

The genomes will be downloaded using the `ncbi-datasets` utility, and the resulting folder structure is 'flattened' to end up with one folder containing all genomes (`.fna` files).

## Run pipeline

Run the pipeline like this:

```bash
snakemake --use-conda --conda-frontend conda --profile slurm-profile
```

Snakemake will send all jobs (except rules defines as `localrules`) to the compute nodes using SLURM. The controller Snakemake job however, runs at the headnode. To be able to leave the terminal running without having it open, consider activating snakemake in a `screen`.

## TODO

- The individual slurm jobs logs are not yet properly stored
- Add another 'module' and separate the prokka module from the new one for organization
- Organize .gitignore file to not commit all results
- Add T3E database to prokka 
