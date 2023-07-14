#!/bin/bash
#PBS -N REMAP
#PBS -P au06
#PBS -l ncpus=16
#PBS -l mem=8GB
#PBS -l walltime=00:10:00
#PBS -l wd
#PBS -l storage=gdata/e14+gdata/ik11+gdata/hh5
#PBS -q normal

module purge
module load openmpi
module load nco
module load esmf/8.1.0
module use /g/data/hh5/public/modules
module load conda/analysis3

# Must be in the parent directory of mom_1deg
# E.g. for me:
# [rmh561@gadi-login-05 custom_topog_test]$ pwd
# /g/data/e14/rmh561/access-om2/input/custom_topog_test
# [rmh561@gadi-login-05 custom_topog_test]$ ls
# make_remap_weights.py  make_remap_weights.sh  mom_1deg
# [rmh561@gadi-login-05 custom_topog_test]$ ls mom_1deg/
# kmt.nc  ocean_hgrid.nc  ocean_mask.nc  topog.nc  topogtools
# [rmh561@gadi-login-05 custom_topog_test]$ ls -lh mom_1deg/ocean_hgrid.nc 
# lrwxrwxrwx 1 rmh561 e14 69 Jul 14 13:41 mom_1deg/ocean_hgrid.nc -> /g/data/ik11/inputs/access-om2/input_20201102/mom_1deg/ocean_hgrid.nc
#

../../tools/make_remap_weights.py ./ /g/data/ik11/inputs/JRA-55/RYF/v1-4/ /g/data/ik11/inputs/access-om2/input_20201102/yatm_1deg/ --atm JRA55 --ocean MOM1 --npes 16

