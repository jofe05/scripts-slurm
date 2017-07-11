#!/bin/bash

SIZE="1000m"

echo "Penguin numademo submitted: $SIZE"
sbatch penguin_numademo.sh $SIZE

echo "Batman numademo submitted: $SIZE"
sbatch batman_numademo.sh $SIZE

echo "Catwoman numademo submitted: $SIZE"
sbatch catwoman_numademo.sh $SIZE
