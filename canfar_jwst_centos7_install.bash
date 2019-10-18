#!/bin/bash

# This script might turn into a Dockerfile some day

# bash love
sudo yum install -y bash-completion

# add EPEL repo for PIP
sudo yum install -y epel-release
sudo yum update -y

# default centos does not have /usr/local/bin in path when sudo'ing
sudo sed -e '/Defaults/s|:/usr/bin|:/usr/local/bin:/usr/bin:|' -i /etc/sudoers

# deps for vos and cadc stuff
sudo yum install -y python36-pip python36-devel fuse-libs idna python-args openssl-devel

# stuff for pip and users might like to have fortran...
sudo yum groupinstall -y 'Development Tools'

#add emacs and X11
sudo yum install -y emacs
sudo yum groupinstall -y "X Window System"

#get ds9
sudo curl http://ds9.si.edu/download/centos7/ds9.centos7.8.0.1.tar.gz | tar xfz -
sudo mv ds9 /usr/bin

#Set up Miniconda3 python for JWST
curl https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh > Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
source ~/.bashrc
#Download JWST pipeline and dependencies
conda create -n jwstdp --file http://ssb.stsci.edu/releases/jwstdp/0.13.8/latest-linux
conda activate jwstdp

#Add useful canfar and python packages
sudo curl -sL https://github.com/canfar/canfarproc/raw/master/worker/bin/canfar_update -o /usr/local/bin/canfar_update
sudo chmod +x /usr/local/bin/canfar_update
sudo canfar_update
#sudo /usr/local/bin/canfar_setup_scratch
sudo /usr/local/bin/canfar_batch_prepare
pip install natsort

#Add CRDS and MIRAGE paths to .bashrc config file
echo 'export CRDS_PATH=/mnt/jwstdata/crds_cache' >> ~/.bashrc
echo 'export CRDS_SERVER_URL=https://jwst-crds.stsci.edu' >> ~/.bashrc
echo 'export MIRAGE_DATA=/mnt/jwstdata/miragereffiles/mirage_data' >> ~/.bashrc
echo 'conda activate jwstdp' >> ~/.bashrc
source ~/.bashrc
which conda

#JWST Pipeline setup
#collect config files - this step may not be needed in the future
mkdir ~/jwstdp
collect_pipeline_cfgs ~/jwstdp/config
#Download example script to run the pipeline on a directory of raw data
curl -sL  https://github.com/chriswillott/canfar/raw/master/runpipelinelevel1.py  -o ~/jwstdp/runpipelinelevel1.py
chmod u+x  ~/jwstdp/runpipelinelevel1.py
curl -sL https://github.com/chriswillott/canfar/raw/master/completesetup.bash  -o completesetup.bash

# cleanup
sudo yum clean all -y


