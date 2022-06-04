# Galaxy-methyl
*Galaxy-methyl* is an parallelized and optimized call-methylation module in [Nanopolish](https://github.com/jts/nanopolish). Given a set of basecalled Nanopore reads and the raw signals, *Galaxy-methy* detects the methylated bases. [f5c](https://github.com/hasindu2008/f5c) is optimised re-implementation of the  *call-methylation* and *eventalign* modules in Nanopolish. *Galaxy-methyl* modified *f5c* to parallelize and optimize the methylation score calculation step on GPU and then pipeline the four steps of the call-methylation module. *Galaxy-methyl* is also be added as a new tool into the Galaxy framework.

# Quickstart 
**Installing**
```
git clone https://github.com/fengyilin118/Galaxy-methyl.git
cd Galaxy-methyl
make cuda=1 CUDA_LIB=/path/to/cuda/library/
```

**Usage**

**Dataset**
