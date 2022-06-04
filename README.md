# Galaxy-methyl
*Galaxy-methyl* is an parallelized and optimized call-methylation module in [Nanopolish](https://github.com/jts/nanopolish). Given a set of basecalled Nanopore reads and the raw signals, *Galaxy-methy* detects the methylated bases. [f5c](https://github.com/hasindu2008/f5c) is optimised re-implementation of the  *call-methylation* and *eventalign* modules in Nanopolish. *Galaxy-methyl* modified *f5c* to parallelize and optimize the methylation score calculation step on GPU and then pipeline the four steps of the call-methylation module. *Galaxy-methyl* is also be added as a new tool into the Galaxy framework.

# Quickstart 

**Installing**
```
git clone https://github.com/fengyilin118/Galaxy-methyl.git
cd Galaxy-methyl
make cuda=1 CUDA_LIB=/path/to/cuda/library/
```

**Dataset**

we use datasets from two different projects from [European Nucleotide Archive (ENA)](https://www.ebi.ac.uk/ena/browser/home) under accession PRJEB23027 and PRJEB13021. Three datasts under accession ERR2184700, ERR2184710 and ERR2184719 in the project PRJEB23027 are lablelled as D1,D2,D3. Three datasets under accession ERR1676719, ERR1676724 and ERR167672 in the project PRJEB13021 are labelled as D3, D4,D5. 

For D1,D2,D3, we use hg38 FASTA Human Reference Genome as the reference genomes.
For D4, we use ECOLI_REFERENCE as the reference genomes.
```
wget ftp://ftp.ensemblgenomes.org/pub/release-29/bacteria//fasta/bacteria_0_collection/escherichia_coli_str_k_12_substr_mg1655/dna/Escherichia_coli_str_k_12_substr_mg1655.GCA_000005845.2.29.dna.genome.fa.gz
```
For D5 and D6, we use HUMAN_REFERENCE as the reference genomes.
```
wget ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_24/GRCh38.primary_assembly.genome.fa.gz
```

**Usage**

Follow the same steps as in [Nanopolish tutorial](https://nanopolish.readthedocs.io/en/latest/quickstart_call_methylation.html). D2 is used as the example dataset.

First, create an index file that links read ids with their signal-level data in the FAST5 files:

```
./f5c index -d FAB41174-3976885577_Multi/fast5 FAB41174-3976885577_Multi/fastq/FAB41174.fastq.gz
```
Next, align the basecalled reads to the reference genome.  minimap2 is used to map reads to the human genome. The output is piped directly into samtools sort to get a sorted bam file:

```
minimap2 -a -x map-ont hg38.fasta FAB41174-3976885577_Multi/fastq/FAB41174.fastq.gz | samtools sort -T tmp -o FAB41174-3976885577_Multi/fastq/FAB41174.sorted.bam
samtools index FAB41174-3976885577_Multi/fastq/FAB41174.sorted.bam
```
Finally, detect methylated bases. -t INT denotes how many threads are launched on CPU cores, and -b FLOAT(K/M/G) denotes the batch size.

```
./f5c call-methylation -t 4 -B 4.0M -r FAB41174-3976885577_Multi/fastq/FAB41174.fastq.gz -b FAB41174-3976885577_Multi/fastq/FAB41174.sorted.bam -g hg38.fasta > methylation_calls.tsv

```

