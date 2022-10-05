FROM nvidia/cuda:10.2-devel-ubuntu18.04
RUN apt-get update && apt-get install -y apt-utils
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git
RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y pkg-config
RUN apt-get update && apt-get install -y zlib1g-dev
RUN apt-get update && apt-get install -y libncurses5-dev
RUN apt-get update && apt-get install -y libbz2-dev
RUN apt-get update && apt-get install -y liblzma-dev
RUN apt-get update && apt-get install -y libcurl4-openssl-dev
WORKDIR /
RUN dir
RUN mkdir /tmp/minimap2
WORKDIR /tmp/minimap2
RUN git clone https://github.com/lh3/minimap2
WORKDIR /tmp/minimap2/minimap2
RUN make
RUN chmod a+x minimap2
RUN mkdir /tmp/samtools
WORKDIR /tmp/samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.16.1/samtools-1.16.1.tar.bz2
RUN tar -xjvf samtools-1.16.1.tar.bz2
WORKDIR /tmp/samtools/samtools-1.16.1
RUN mkdir /tmp/samtools/samtools/
RUN ./configure --prefix=/tmp/samtools/samtools/
RUN make
RUN make install
WORKDIR /tmp/samtools/samtools/
RUN chmod a+x /tmp/samtools/samtools/bin/samtools
RUN mkdir /tmp/Galaxy-methyl
WORKDIR /tmp/Galaxy-methyl
RUN git clone https://github.com/fengyilin118/Galaxy-methyl.git
WORKDIR /tmp/Galaxy-methyl/Galaxy-methyl
RUN make cuda=1
RUN chmod a+x Galaxy-methyl
CMD ./Galaxy-methyl index -d /dataset/fast5_files /dataset/albacore_output.fastq
CMD /tmp/minimap2/minimap2/minimap2 -a -x map-ont /dataset/reference.fasta /dataset/albacore_output.fastq | /tmp/samtools/bin/samtools sort -T tmp -o /dataset/albacore_output.sorted.bam
CMD /tmp/samtools/bin/samtools index /dataset/albacore_output.sorted.bam
WORKDIR /tmp/Galaxy-methyl/Galaxy-methyl
CMD ./Galaxy-methyl call-methylation -t 8 -r /dataset/albacore_output.fastq -b /dataset/albacore_output.sorted.bam -g /dataset/reference.fasta  > /dataset/methylation_calls.tsv
