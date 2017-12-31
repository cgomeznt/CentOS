#!/bin/bash
######################################################################################################
# Script para copiar y ejecutar un script remoto
#______________________________________________________________
# Creado por Carlos Gomez
# Correo: cgome1@cantv.com.ve
# Fecha: 17-04-2015
# CANTV - GOTIC - CSMBD
######################################################################################################

function escribirLog {
   tee -a $ruta_log$scriptname.log
}

function escribirLogCopia {
   tee -a $ruta_log$scriptname-Copias.log
}

function mensajeError {
   echo $"ERROR - `fechaHora` -  $1 - Se sale del script, verifique en la ruta indicada" | escribirLog
   echo $" "
   exit 1
}

function mensajeWarm {
   echo $"WARN - `fechaHora` - $1" | escribirLog
}

function mensajeInfo {
   echo $"INFO - `fechaHora` - $1" | escribirLog
}

function fechaHora {
   ANO=`date +"%Y"`
   MES=`date +"%m"`
   DIA=`date +"%d"`
   HORA=`date +%H`
   MIN=`date +%M`
   FECHA="$DIA-$MES-$ANO $HORA:$MIN"
   echo $FECHA
}

function leerServidores {
   cat ./servidores.txt
}

function mostrar {
   for i in `leerServidores` ; do echo $i ; done | escribirLog
}

function copiarScript {
   for i in `leerServidores` ; do sshpass -p $arg2 scp inventario.sh $i:/tmp | escribirLog ; done
}

function ejecutarScript {
   for i in `leerServidores` ; do sshpass -p $arg2 ssh $i -t 'sudo /tmp/inventario.sh' | escribirLog ; done  
}

function crearCarpetas {
   for i in `leerServidores` ; do mkdir tmp/$i ; done 
}

function respaldarUsrLocalBin {
    for i in `leerServidores` ; do sshpass -p $arg2 ssh $i "tar -cvf - /usr/local/bin/" | tar -xvf - -C tmp/$i | escribirLogCopia ; done
}

function respaldarEtc {
    for i in `leerServidores` ; do sshpass -p $arg2 ssh $i "tar -cvf - /etc/" | tar -xvf - -C tmp/$i ; done
}
###############################################################
# MAIN
###############################################################

scriptname=$0
arg1=$1
arg2="Android!21"
ruta_log="/tmp/"
echo "Copiando el script"
copiarScript
echo "Ejecutando el script"
ejecutarScript
crearCarpetas
respaldarUsrLocalBin
#respaldarEtc



