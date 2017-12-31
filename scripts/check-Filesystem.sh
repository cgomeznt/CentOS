#!/bin/bash

######################################################################################################
# Script para verificar que el ramdisk no llegue al 100%
# si pasan del umbral procede a ejecutar el comando ramdisk.sh
# 0 1 * * 5 /usr/local/bin/check-ramdisk.sh
#______________________________________________________________
# Creado por Carlos Gomez
# Correo: cgome1@cantv.com.ve
# Fecha: 08-09-2014
# CANTV - GOTIC - CSMBD
######################################################################################################

PATH=$PATH:/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/lib/oracle/11.2/client/bin:/root/bin
ORACLE_HOME=/usr/lib/oracle/11.2/client
PERL5LIB=:/usr/local/nsproxy/etc
export PATH
export ORACLE_HOME
export PERL5LIB

function enviarCorreo {
    mail -s "RADIUS `hostname` se reinicio el Ramdisk" $strCorreo < /var/tmp/check-ramdisk.log
}

function detenerRamdisk {
    `/usr/local/bin/ram-disk.sh stop >> /var/tmp/check-ramdisk.log`
    sleep 15
    iniciarRamdisk
}

function iniciarRamdisk {
    `/usr/local/bin/ram-disk.sh start >> /var/tmp/check-ramdisk.log`
}

function validarUmbral {
    if [ $1 -ge $valorUmbral ] ; then
        echo "El umbral es de: $valorUmbral% y el Ramdisk tenia: $1%, se procedio a reiniciar" > /var/tmp/check-ramdisk.log
        detenerRamdisk
        enviarCorreo
    fi
}

function validarPuntoDeMontaje {
    if [ x$1 != x ] ; then
        #echo "El Ramdisk esta montado"
        validarUmbral $strPorcentajeUso
    else
        #echo "No esta montado el Ramdisk"
        iniciarRamdisk
        exit 1
    fi
}

###############################################################
# MAIN
###############################################################
strCorreo="sopmid@cantv.com.ve"
puntoMontaje="/var/cache/nrsd"
valorUmbral=$1
strMontaje=`df -h | grep $puntoMontaje`
strPorcentajeUso=`df -h | grep $puntoMontaje | awk '{print $5}' | sed 's/%//'`
validarPuntoDeMontaje $strMontaje

