#!/bin/bash

# File: AcetoScan_cutadapt.sh
# Last modified: fre jul 19, 2019 20:56
# Sign: Abhi

# Cutadapt script for cleaning ILLUMINA read data, 
# requires already demplutiplexed data in the form of 
# SAMPLE_R*_001.fastq.gz.

command -v cutadapt >/dev/null 2>&1 || { echo >&2 "Error: cutadapt not found."; exit 1; }

cutadapt_dir="${WKDIR}/output_data/trimmed"

cutadapt_out="${WKDIR}/output_data/cutadapt.out"

echo "cutadapt $(date) :" > "${cutadapt_out}"

for FwdIn in *"${reads}"*.fastq.gz; do

  if [ ! -e "$FwdIn" ]; then
        echo "Error: No *.fastq.gz files found in ${PWD}"
        break
    else
        FwdOut="${FwdIn%%_*}_trimmed_"${reads}".fasta"
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
            "${FwdIn}" >> "${cutadapt_out}"
    fi
done

### End of script