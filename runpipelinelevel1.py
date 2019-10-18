#!/usr/bin/env python

import sys
import os
import subprocess
import natsort
import jwst
from jwst.pipeline import Detector1Pipeline

if len(sys.argv) < 1:
    print ('You must specify the input directory')
    print ('e.g. ./runpipelinelevel1.py  indir')
    sys.exit()

rawdir = sys.argv[1]

print('pipeline:',jwst.__version__)

#define config dir
configdir='./config/'

#set up subdirectory to hold results of processing
outdir=rawdir+'pipeout/'
if not os.path.exists(outdir):
    os.makedirs(outdir)

#Find files to be processed
dirlist=natsort.natsorted(os.listdir(rawdir))
dirlist[:] = (value for value in dirlist if value.startswith('jw') and value.endswith('.fits'))
numimages=len(dirlist)
print (numimages)

#Iterate over files and run pipeline
for j in range(numimages):
    uncal_image=rawdir+dirlist[j]
    config=configdir+'calwebb_detector1.cfg'
    result = Detector1Pipeline.call(uncal_image, config_file=config, output_dir=outdir, save_results=True)
