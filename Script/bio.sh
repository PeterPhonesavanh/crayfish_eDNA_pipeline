#!/bin/bash
cd /home/bt24738/bt24738/scripts
chmod +x bio.sh
./bio.sh

###########################################################COI (from barcode01 to barcode09)############################################################################
#DO THE SAME FROM BARCODE01 TO BARCODE09 - The following script will give barcode06 as example
##### 1. Navigate to data directory - all input file saved in this directory
cd /home/bt24738/bt24738/barcode06
ls
##### 2. Combine all fastq.gz into one big file 
cat *.fastq.gz > data06.fastq.gz
## extract the zipped file -> delete the zipped file to clear up the space
## the output file now is data06.fastq
##### 3. Install Nanoplot/Nanofilt and use NanoPlot to visualize the data 
## Install Nanoplot 
export PATH=$HOME/.local/bin:$PATH
pip install --user NanoPlot Nanofilt
pip install --user "numpy>=1.17.3,<1.25.0" "scipy==1.10.1"
pip install --user "plotly>=6.1.1" "kaleido==0.2.1" "numexpr>=2.8.4" "bottleneck>=1.3.6"
## Run nanoplot
NanoPlot --fastq /home/bt24738/bt24738/barcode06/data06.fastq --loglength
## result from nanoplot will dispaly the data requiring for filter in the next step. 
##### 4. Run Nanofilt for filter the reads we target
NanoFilt -q 12 --length 600 --maxlength 900 < /home/bt24738/bt24738/barcode06/data06.fastq > /home/bt24738/bt24738/barcode06/filterred06.fastq
## the output file is now filterred06.fastq
#### 5. Install porechop and run Adaptor trimming using porechop 
## install porechop for github
export PATH="$HOME/.local/bin:$PATH"
git clone https://github.com/rrwick/Porechop.git
cd Porechop
python setup.py install --user
## Run the porechop 
## navigate to directory 
cd /home/bt24738/bt24738/barcode06
porechop -i filterred06.fastq -o trimmedatrimmed06.fastq
## the output file is now trimmedatrimmed06.fastq
##### 6. Install Cutadapt and trim primers trimming using Cutadapt
## Install cutadapt 
export PATH="$HOME/.local/bin:$PATH"
pip install --user cutadapt
## barcode01 to barcode09 are COI
## Forward - GGTCAACAAATCATAAAGATATTGG; Reversed - TAAACTTCAGGGTGACCAAAAAATCA
cutadapt -g GGTCAACAAATCATAAAGATATTGG \
         -a TAAACTTCAGGGTGACCAAAAAATCA \
         -m 600 \
         --discard-untrimmed \
         -o trimmed_06.fastq \
         trimmedatrimmed06.fastq
## Output file is trimmed_06.fastq
##### 7. Activate conda environment
conda activate version-env
##### 8. Use VSEARCH to Convert fastq to fasta file for OTU
vsearch --fastq_filter trimmed_06.fastq --fastaout trimmed_06.fasta --fastq_qmax 50
##### 9. Use VSEARCH to dereplicate/collapses identical sequences into a single
vsearch --derep_fulllength trimmed_06.fasta \
        --output dereplicated_trimmed06.fasta \
        --sizeout
## Output file is dereplicated_trimmed06.fasta.fasta to cluster in OTU format 
##### 10. Use VSEARCH to cluster
vsearch --cluster_size dereplicated_trimmed06.fasta \
        --id 0.97 \
        --centroids otus_06.fasta \
        --relabel OTUs_ \
        --sizeout
##### 11. Assign Taxonomic using VSEARCH to blast with reference sequence 
## Four reference databases use: (1) MIDORI2.fasta, (2) Pr2_18S.fasta, (3) custom_NCBI_COI.fasta, (4) custom_NCBI_18S.fasta, all save in the same directory 
vsearch --usearch_global otus_01.fasta \
        --db MIDORI2.fasta \
        --id 0.90 \
        --blast6out result.txt \
        --top_hits_only \
        --maxaccepts 1 \
        --maxrejects 8
## from barcode01 to barcode09, use (1) and (2) 
##### 12. Repeat the process until barcode09

#############################################################18S (from barcode09 to barcode18)######################################################################
#DO THE SAME FROM BARCODE10 TO BARCODE19 - The following script will give barcode10 as example
##### 1. Navigate to data directory - all input file saved in this directory
cd /home/bt24738/bt24738/barcode10
ls
##### 2. Combine all fastq.gz into one big file 
cat *.fastq.gz > data10.fastq.gz
## extract the zipped file -> delete the zipped file to clear up the space
## the output file now is data10.fastq
##### 3. Install Nanoplot/Nanofilt and use NanoPlot to visualize the data 
## Install Nanoplot 
export PATH=$HOME/.local/bin:$PATH
pip install --user NanoPlot Nanofilt
pip install --user "numpy>=1.17.3,<1.25.0" "scipy==1.10.1"
pip install --user "plotly>=6.1.1" "kaleido==0.2.1" "numexpr>=2.8.4" "bottleneck>=1.3.6"
## Run nanoplot
NanoPlot --fastq /home/bt24738/bt24738/barcode10/data10.fastq --loglength
## result from nanoplot will dispaly the data requiring for filter in the next step. 
##### 4. Run Nanofilt for filter the reads we target
NanoFilt -q 12 --length 300 --maxlength 600 < /home/bt24738/bt24738/barcode10/data10.fastq > /home/bt24738/bt24738/barcode10/filterred10.fastq
## the output file is now filterred10.fastq
#### 5. Install porechop and run Adaptor trimming using porechop 
## install porechop for github
export PATH="$HOME/.local/bin:$PATH"
git clone https://github.com/rrwick/Porechop.git
cd Porechop
python setup.py install --user
## Run the porechop 
## Some barcodes that are too big, split it and run porechop separately then combine them.
## navigate to directory 
cd /home/bt24738/bt24738/barcode10
porechop -i filterred10.fastq -o trimmedatrimmed10.fastq
## the output file is now trimmedatrimmed10.fastq
##### 6. Install Cutadapt and trim primers trimming using Cutadapt
## Install cutadapt 
export PATH="$HOME/.local/bin:$PATH"
pip install --user cutadapt
## barcode10 to barcode18 are 18S
## Forward - TTGAACACACGCCCGCTCGC; Reversed - CCTTCYGCAGGTTCACCTAC
cutadapt -g TTGAACACACGCCCGCTCGC \
         -a CCTTCYGCAGGTTCACCTAC \
         -m 300 \
         --discard-untrimmed \
         -o trimmed_10.fastq \
         trimmedatrimmed10.fastq
## Output file is trimmed_10.fastq
##### 7. Activate conda environment
conda activate version-env
##### 8. Use VSEARCH to Convert fastq to fasta file for OTU
vsearch --fastq_filter trimmed_10.fastq --fastaout trimmed_10.fasta --fastq_qmax 50
##### 9. Use VSEARCH to dereplicate/collapses identical sequences into a single
vsearch --derep_fulllength trimmed_10.fasta \
        --output dereplicated_trimmed10.fasta \
        --sizeout
## Output file is dereplicated_trimmed10.fasta.fasta to cluster in OTU format 
##### 10. Use VSEARCH to cluster 
vsearch --cluster_size dereplicated_trimmed10.fasta \
        --id 0.97 \
        --centroids otus_10.fasta \
        --relabel OTUs_ \
        --sizeout
##### 11. Assign Taxonomic using VSEARCH to blast with reference sequence 
## Four reference databases use: (1) MIDORI2.fasta, (2) Pr2_18S.fasta, (3) custom_NCBI_COI.fasta, (4) custom_NCBI_18S.fasta, all save in the same directory 
vsearch --usearch_global otus_10.fasta \
        --db Pr2_18S.fasta \
        --id 0.90 \
        --blast6out result.txt \
        --top_hits_only \
        --maxaccepts 1 \
        --maxrejects 8
## from barcode10 to barcode18, use (3) and (4)
##### 12. Repeat the process until barcode18
