#!/bin/bash 

while true
do 
  for u in $(seq 10)
do 
    H=$(tput cup $u $u)
    C=$(tput setab $u)
    echo $H
    echo $u $C
    sleep 1
done
F=$(tput sgr0)
echo $F
done
