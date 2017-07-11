#!/bin/bash

repeats=1
file="gcat_set_039_1"


x=1
while [ $x -le 5 ]
do
  echo "RUN $x"
  
  echo "Submitting ALN on BATCAT: "
#sbatch aln.part.batcat.sh $file $repeats

#echo "Submitting ALN on PENGUIN: "
#sbatch aln.part.penguin.sh $file $repeats

#echo "Submitting MEM on BATCAT: "
#sbatch mem.part.batcat.sh $file $repeats

#echo "Submitting MEM on PENGUIN: "
#sbatch mem.part.penguin.sh $file $repeats

#echo "Submitting BOWTIE2 on BATCAT: "
#sbatch bowtie2.part.batcat.sh $file $repeats
#echo "Submitting BOWTIE2 on PENGUIN: "
#sbatch bowtie2.part.penguin.sh $file $repeats

#echo "Submitting GEM on BATCAT: "
#sbatch gem.part.batcat.sh $file $repeats
#echo "Submitting GEM on PENGUIN: "
#sbatch gem.part.penguin.sh $file $repeats

echo "Submitting SNAP on BATCAT: "
sbatch snap.part.batcat.sh $file $repeats
echo "Submitting SNAP on PENGUIN: "
sbatch snap.part.penguin.sh $file $repeats

#echo "Submitting NOVO on BATCAT: "
#sbatch novo.part.batcat.sh $file $repeats
#echo "Submitting NOVO on PENGUIN: "
#sbatch novo.part.penguin.sh $file $repeats

  x=$(( $x + 1 ))
done



