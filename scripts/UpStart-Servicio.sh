#!/bin/bash
######################################################################################################
# Script encargado de hacer el principio de upstart o systemd en los sistemas init
#______________________________________________________________
# Creado por Carlos Gomez
# Correo: cgome1@cantv.com.ve
# Fecha: 01-09-2014
# CANTV - GOTIC - CSMBD
######################################################################################################

function escribir_log {
   tee -a $rutaLog$nombreLog
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

function mensajeError {
   echo "ERROR - `fechaHora` - $mensajeLog" | escribir_log
   exit 1
}

function mensajeWarn {
   echo "WARN - `fechaHora` - $mensajeLog" | escribir_log
   exit 1
}

function mensajeInfo {
   echo $"INFO - `fechaHora` - $mensajeLog" | escribir_log
}

function obtenerMensaje {
    echo -e "1.No existe el servicio: $nombreServicio
    2.EL PID del Servicio $nombreServicio es: $PID_Servicio
    3.no se pudo obtener el PID del Servicio $nombreServicio
    4.El servicio $nombreServicio con el PID $obtenerPID fue detenido
    5.EL servicio $nombreServicio ya esta arriba con el PID: $PID_Servicio
    6.El servicio $nombreServicio se inicio con exito
    7.No se pudo iniciar el servicio: $nombreServicio, se desconoce el error
    8.Debe utilizar <start|stop|restart|status> como segundo argumento
    9.Debe colocar como segundo argumento <start|stop|restart|status> 
    10.Debe colocar como primer argumento el nombre del Servicio
    11.Se inicio el script"
}

function validarExisteServicio {
    servicioExiste=`find $rutaServicio -name $nombreServicio`
    if [ -z $servicioExiste ] ; then
        mensajeLog="No existe el servicio: $nombreServicio"
        mensajeError
    fi
}

function obtenerStatus {
    obtenerPID
    if [ x$obtenerPID != x ] ; then
        mensajeLog=`obtenerMensaje | grep  "2\." | awk -F"." '{print $2}'`
        mensajeInfo $mensajeLog
    else
        mensajeLog=`obtenerMensaje | grep  "3\." | awk -F"." '{print $2}'`
        mensajeWarn $mensajeLog
    fi
}

function detenerServicio {
   obtenerPID
    if [ x$obtenerPID == x ] ; then
        mensajeLog=`obtenerMensaje | grep  "3\." | awk -F"." '{print $2}'`
        mensajeWarn $mensajeLog
    else
       while [ x$obtenerPID != x ] ; do 
         $rutaServicio$nombreServicio stop
         #mensajeLog="El proceso  $obtenerPID, aun esta corriendo, espere por favor !!!"
         sleep 5 
         mensajeLog=`obtenerMensaje | grep  "4\." | awk -F"." '{print $2}'`
	 obtenerPID
      done
      mensajeInfo $mensajeLog
    fi
}

function iniciarServicio { 
    obtenerPID
    if [ x$obtenerPID != x ] ; then
        mensajeLog=`obtenerMensaje | grep  "5\." | awk -F"." '{print $2}'`
        mensajeWarn $mensajeLog
    else
       $rutaServicio$nombreServicio start
       if [ $? -eq 0 ] ; then
           mensajeLog=`obtenerMensaje | grep  "6\." | awk -F"." '{print $2}'`
       else
           mensajeLog=`obtenerMensaje | grep  "7\." | awk -F"." '{print $2}'`
           mensajeError $mensajeLog
       fi
       obtenerPID
       mensajeLog="$mensajeLog - con el PID $obtenerPID"
       mensajeInfo $mensajeLog
    fi
}

function obtenerPID {
   #PID_newreglocal=`ps -elf |grep apache2 | grep -v grep |awk '{if ($5 == 1) print $4}'`
   PID_Servicio=`/bin/ps -elf | /bin/grep $nombreServicio | /bin/grep -v grep | /usr/bin/awk '{if ($5 == 1) print $4}'`
   if [ $? -eq 0 ] && [ ! -z $PID_Servicio ] ; then
      obtenerPID=$PID_Servicio
   else 
      obtenerPID=$PID_Servicio
   fi
}

###############################################################
# MAIN
###############################################################

scriptName=$0
arg1=$1
arg2=$2
sw=""
mensajeLog=""
rutaLog="/var/tmp/"
nombreLog="upstart.log"
rutaServicio="/etc/init.d/"
nombreServicio=$1
servicioProceso=$2

mensajeLog=`obtenerMensaje | grep  "11\." | awk -F"." '{print $2}'`
mensajeInfo $mensajeLog

if [ ! -z $arg1 ] ; then
    validarExisteServicio
    if [ ! -z $arg2 ] ; then
        case $arg2 in
           start)
               iniciarServicio
           ;;
           stop)
               detenerServicio
           ;;
           restart)
               detenerServicio
               iniciarServicio
           ;;
           status)
               obtenerStatus
           ;;
           *)
               mensajeLog=`obtenerMensaje | grep  "8\." | awk -F"." '{print $2}'`
               mensajeError $mensajeLog
           ;;
       esac
    else
        mensajeLog=`obtenerMensaje | grep  "9\." | awk -F"." '{print $2}'`
        mensajeError $mensajeLog
    fi
    
else
    mensajeLog=`obtenerMensaje | grep  "10\." | awk -F"." '{print $2}'`
    mensajeError $mensajeLog
fi
