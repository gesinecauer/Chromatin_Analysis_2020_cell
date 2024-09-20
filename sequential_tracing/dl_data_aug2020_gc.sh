#!/usr/bin/env bash

set -o nounset
set -euo pipefail
set -o errexit

# **General info**
# 	The genomic coordinates used in all data files are from the hg38 assembly.
# 	These Hi-C contact matrices, generated using Hi-C data published in Rao et al, Cell 2014, correspond to the genomic loci imaged in our work. To generate these Hi-C matrices, we created bins centered around the regions that we imaged and procured Hi-C data for these bins by summing the number of reads in higher resolution Hi-C data. The bin size used for the high-resolution Chr21 and Chr2 coordinates was 50 kb (same as the size of the targeted loci in imaging). The bin size used for the genomic-scale coordinates is 500 kb. We used a larger bin size in this case since the detected Hi-C contacts are relatively sparse for long-range interactions.
# 	Tab-delimited data files (.tsv) for sequential hybridization and DNA-MERFISH experiments contain the 3D positions of the genomic loci
# **Sequential hybridization**, separated for each imaged chromosomal copy:
# 	`chromosome21.tsv` - chromosome 21
# 		In separate columns: (1) the genes measured within each locus, (2) their transcriptional states, (3) the 3D positions of the corresponding 5kb chromatin segments around their transcription starts sites.
# 	`chromosome21-cell_cycle.tsv` - a replicate chromosome 21
# 		In this replicate, we also imaged cell-cycle markers
# 		In separate columns: (1) the genes measured within each locus, (2) their transcriptional states, (3) the 3D positions of the corresponding 5kb chromatin segment around the transcription starts sites, (4) cell cycle phases of the cells
# 	`chromosome2.tsv` - chromosome 2
# 	`chromosome2_p-arm_replicate.tsv` - the p-arm of Chromosome 2 replicate data, which has NOT been included in the Chromosome 2 p-arm analyses shown in the paper
# **DNA-MERFISH**, genome-scale, separated for each homologous copy of each chromosome in each single cell:
# 	`genomic-scale.tsv`
# 		Extra columns: (1) the distances from the imaged loci to the nuclear lamina. 
# 		3 replicate experiments are included in this file.
# 	`genomic-scale-with transcription and nuclear bodies.tsv`
# 		Extra columns: (1) for each locus whether the genes measured within it are actively transcribing and the distances from the locus to the nuclear lamina, (2) the nearest nuclear speckle, (3) the nearest nucleolus.
# 		2 replicate experiments are included in this file.
# 	`genomic-scale-amanitin.tsv` - For cells treated with α-amanitin
# 		Extra columns: (1) for each locus its distances to the nuclear lamina, (2) the nearest nuclear speckle and nearest nucleolus where available.
# 		2 replicate experiments are included in this file. We only measured the nuclear speckles and nucleoli in the first experiment.
# **Binned Hi-C contact matrices:**
# 	`Hi-C_contacts_chromosome21.tsv`: Chromosome 21
# 	`Hi-C_contacts_chromosome2.tsv`: Chromosome 2
# 	`Hi-C_contacts_genome-scale.tsv`: Genome-scale


url="https://zenodo.org/records/3928890/files"
datadir="data"
chromtrace="$datadir/nobackup/zenodo_dl/chrom_trace"
hic="$datadir/nobackup/zenodo_dl/hi-c"

# Download README
if [ ! -f "$datadir/README_August2020.txt" ]; then
	wget "$url/README_August%202020.txt" -O "$datadir/README_August2020.txt"
fi

# Download sequential hybridization (chromosome tracing)
for f in "21" "21-cell_cycle" "2" "2_p-arm_replicate"; do
	if [ ! -f "$chromtrace/chr$f.tsv" ]; then
		echo "Download sequential hybridization:  chr$f"
		wget "$url/chromosome$f.tsv" -O "$chromtrace/chr$f.tsv"
	fi
done

# Download Hi-C data (Rao et al, Cell 2014)
for f in "21" "2"; do
	if [ ! -f "$hic/chr$f.tsv" ]; then
		echo "Download Hi-C:  chr$f"
		wget "$url/Hi-C_contacts_chromosome$f.tsv" -O "$hic/chr$f.tsv"
	fi
done
