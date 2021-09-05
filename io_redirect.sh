#! bin/bash
# Scipt to store output and errors in file instead of screen 
echo 'Name of the script' $1 1> input.dat
echo 'The error in the script' 2>input.dat
