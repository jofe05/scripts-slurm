#!/bin/bash

job=$1
num=20
x=1
while [ $x -le $num  ]
do
  echo "scancel $job"
  scancel $job 
  x=$(( $x + 1 ))
  job=$(($job + 1))
done
