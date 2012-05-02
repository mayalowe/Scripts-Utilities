#!/bin/bash
# a bash script to move multiple dirs to a specified dir
# script looks at all files in $PWD, tests if they are
# a dir, and then moves them sequentially
# Usage: move_dir.sh [new_dir]
# NOTE: I hope to add command-line dir specification
# by use of globbing/wildcards

new_dir=$1
new_dir=${new_dir:? 'Missing dir to move to'}
echo $new_dir

for i in $PWD/*
do
    if [ -d $i ]
    then
	echo $i
#	mv $i $new_dir
    fi
done