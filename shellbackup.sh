#!/bin/bash 

#SCRIPT EM CONSTRUCAO

ARQ="/home/reis/Desktop/TWD/"
SAVE_BACKUP="/home/reis/"
DATE=$(date +"%d-%m-%y")
NAME="BACKUP-TWD-$DATE.tar.bz2"


if [ -d $ARQ ];then 
 
    tar cjf $SAVE_BACKUP$NAME  $ARQ 2> /dev/null 
fi


if [ -e $SAVE_BACKUP$NAME ];then 

 echo "BACKUP EXECUTADO COM SUCESSO $DATE E SALVO EM $SAVE_BACKUP" >> ./log_backup_ged.txt

else

  echo "BACKUP EXECUTADO COM ERRO $DATE" >>./log_backup_ged.txt

fi   
