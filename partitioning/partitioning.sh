#!/bin/bash

number_runs=5
 
#function run
run() {
    number=$1
    shift
    for i in `seq $number`; do
      $@
    done
}

 

run $number_runs ls 

