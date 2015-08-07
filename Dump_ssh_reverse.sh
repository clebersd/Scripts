#!/bin/bash
#Prototipo de sniffer de rede remoto
#
echo "[#] SNIFFER REMOTO VIA SSH"

RSA="~./ssh/id_rsa.pub"

if [ -e "$RSA" ]
  then
      echo "[#] CHAVE EXISTENTE LOCALIZADA NO DIRETORIO : $RSA"
else
      echo "[#] ANTES DE UTILIZAR A TOOL FAVOR CRIAR SUA CHAVE DE ACESSO SSH"
      echo "[#] CHAVE SENDO GERADA FAVOR AGUARDAR"

      `/usr/bin/ssh-keygen -b 1024 -t rsa > /dev/null`
fi



#loop="127.0.0.1"

#DADOS=$(tcpdump -i  wlan0 -n   | grep -i IP | cut -f 3-5 -d  | sed -n  's/\://pg')


#`/bin/ssh -N -L  8080:$loop:3040 $1 `
