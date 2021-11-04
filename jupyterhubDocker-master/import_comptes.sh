#!/bin/bash

# Creation automatique de comptes
# entree : fichier CSV separe par ;
# login;passwd ou alors login;passwd;1 pour les profs


FICH=$1
ADMIN="adminjh"
echo $FICH
for i in `cat $FICH`
do
USER=`echo $i | awk -F";" '{ print $1 }'`
PASS=`echo $i | awk -F";" '{ print $2 }'`
PROF=`echo $i | awk -F";" '{ print $3 }'`

/usr/sbin/useradd $USER -s /bin/bash
echo "$USER:$PASS" | /usr/sbin/chpasswd

chown $USER /home/$USER


done
