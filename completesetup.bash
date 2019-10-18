#!/bin/bash

#Set up scratch disk for data
sudo canfar_setup_scratch

#Set up canfar authentication
cadc_dotnetrc
getCert --daysValid=15

#Copy a small JWST data file onto ephemeral and run pipeline on it
#Note when running the pipeline for the first time some reference fiels are automatically downloaded so it takes some time
#(this can be done in a notebook later or can be turned into a batch job with multiple files to process)
mkdir /mnt/scratch/jwstdata
mkdir /mnt/scratch/jwstdata/test
vcp vos:cjw/jw11111001001_01101_00001_NIS_uncal.fits /mnt/scratch/jwstdata/test/
cd jwstdp
./runpipelinelevel1.py /mnt/scratch/jwstdata/test/
ds9 /mnt/scratch/jwstdata/test/pipeout/jw11111001001_01101_00001_NIS_rate.fits &
