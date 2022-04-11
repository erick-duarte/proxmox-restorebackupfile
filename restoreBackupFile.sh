#!/bin/bash

directory='/DIRECTORY'
backupfile=$1
storagename=$2
prefix='@'

if [ -f $directory/$backupfile ]
then
     namefile=`echo $backupfile | cut -d"$prefix" -f2`
     echo "Backup file name: $namefile"

     cp -v $directory/$backupfile /tmp/$namefile

     if [ -f /tmp/$namefile ]
     then
          echo "Moved file: /tmp/$namefile"
     else
          echo "File not moved"
          exit 0
     fi

     lastqmid=`qm list | awk '{print $1}' | tail -n 1`
     newqmid=`expr $lastqmid + 1` #get the next available id

     if [ -f /tmp/$namefile ]
     then
          if [ $newqmid > $lastqmid ]
          then
               echo "Restoring backup: $namefile"
               qmrestore /tmp/$namefile $newqmid --storage $storagename
               exit 0
          fi
     fi
else
     echo "File does not exist in backup directory"
     exit 0
fi
