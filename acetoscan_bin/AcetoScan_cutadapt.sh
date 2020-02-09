#!/bin/bash

# File: AcetoScan_cutadapt.sh
# Last modified: Ons Feb 09, 2020 17:35
# Sign: Abhi

# Cutadapt script for cleaning ILLUMINA read data, 
# requires already demplutiplexed data in the form of 
# SAMPLE_R*_001.fastq.(gz|bz2).

command -v cutadapt >/dev/null 2>&1 || { echo >&2 "Error: cutadapt not found."; exit 1; }

cutadapt_dir="${WKDIR}/output_data/trimmed"

cutadapt_out="${WKDIR}/output_data/cutadapt.out"

echo "cutadapt $(date) :" > "${cutadapt_out}"

for infile in $(find "${WKDIR}/input_data/" -maxdepth 1 -type l -name "*_R1_001.fastq.gz" ); do

#for FwdIn in *"${reads}"*.fastq."${INfileext}"; do

  if [ ! -L "${infile}" ]; then
        echo "Error: No *.fastq.'${INfileext}' files found in ${PWD}"
        break
    else
    	  In=`echo ${infile} | rev | cut -d "/" -f1 | cut -d. -f3,4,5,6,7,8,9,10 | rev | sed 's/_L001_R1_001//'`
        FwdOut="${In}_trimmed_"${reads}".fasta"
        cutadapt \
            -b "CCNACNCCNNNNGGNGANGGNAA" \
            -b "GGNTGNGGNNNNCCNCTNCCNTT" \
            -b "ATNTTNGCNAANGGNCCNNCNTG" \
            -b "TANAANCGNTTNCCNGGNNGNAC" \
            --max-n 0 \
            --maximum-length $MaxL \
            --minimum-length $MinL \
            --discard-untrimmed \
            -j 0 \
            -q $QT \
            --length-tag "size=" \
            -o "${cutadapt_dir}/${FwdOut}" \
            "${infile}" >> "${cutadapt_out}"
    fi
done

### End of script
