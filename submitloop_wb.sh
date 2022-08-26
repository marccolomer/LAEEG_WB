#!/bin/bash

#This script will loop over files in a directory with .mat extension
#File names are passed to a qsub submit script
#The submit script sets the file name as an environment variable
#The environment variable is read into Matlab 

#Reads in fils in the subject_files folder with .set file extension
FILES=/share/woodwardlab/Chung/LAEEG_12m/avg_trial_complex_data2/*.mat
for loopsubject in $FILES
do
  #File names are assigned to the loopsubject variable
  echo "$loopsubject"
    #Value of loopsubject is assigned to qsub_subject variable to be used in matlab.qsub submit script
    qsub -v qsub_subject=$loopsubject matlab_wb.qsub
done
