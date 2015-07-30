#!/bin/bash
# Script para efetuar scan de rede 
# Coder: Cleber Reis

for a in $(seq 254);

do 
    `/bin/ping -c 3 192.168.1.$a > /dev/null` 
if [ $? -eq 0 ];then 

echo "host 192.168.1.$a UP "

else 

 echo "host 192.168.1.$a DOWN"

fi   
    

done 

