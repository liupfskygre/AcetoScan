#!/bin/bash

# File: AcetoScan_software_check.sh
# Last modified: fre jul 19, 2019 20:49
# Sign: Abhi

###     User

user=`echo ${SUDO_USER:-${USER}}`

###     Checking if cutadapt is installed
if ! command -v "cutadapt" > /dev/null ; then
    echo -e "\n#Error: cutadapt not found, Aborting !!!"
    exit 1
fi

###     Checking if vsearch is installed
if ! command -v "vsearch" > /dev/null ; then
    echo -e "\n#Error: vsearch not found, Aborting !!!"
    exit 1
fi

###     Checking if Blast is installed
if ! command -v "blastx" > /dev/null ; then
    echo -e "\n#Error: NCBI Blast+ (blastx) not found, Aborting !!!"
    exit 1
fi

###     Checking if Bioperl is installed

if ! command -v perl -MBio::SeqIO -e 'printf "%vd\n", $Bio::SeqIO::VERSION, "\n"' > /dev/null ; then
echo -e "\n#Error: Bioperl not found, Aborting !!!"
    exit 1
fi

###     Checking if R and Rscript are installed
if ! command -v "R" > /dev/null ; then
    echo -e "\n#Error: R not found, Aborting !!!"
    exit 1
fi
#
if ! command -v "Rscript" > /dev/null ; then
    echo -e "\n#Error: Rscript not found, Aborting !!!"
    exit 1
fi

###     Checking if acetobase is formatted and accessible

if [ ! -f /home/$user/acetoscan/acetobase/*.phr ];then
        echo -e "\n#Cannot access acetobase"
        echo -e "\n#Trying to Download AcetoBase"
        wget -O /home/$user/acetoscan/acetobase/AcetoBase_V1.tar.gz https://acetobase.molbio.slu.se/download/acetobase_ref_protein
        tar xf /home/$user/acetoscan/acetobase/AcetoBase_V1.tar.gz -C /home/$user/acetoscan/acetobase/ 
        find /home/$user/ -type f -iname "AcetoBaseV1.fasta" -exec cp {} /home/$user/acetoscan/acetobase/AcetoBaseV1.fasta
        cd /home/$user/acetoscan/acetobase/ && makeblastdb -in AcetoBaseV1.fasta -dbtype prot -title AcetoBaseV1 -out AcetoBaseV1
fi

###     End of script