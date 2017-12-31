#!/bin/bash

<<COMMENT
Script que realiza una conexion con un servidor, obtiene sus cabeceras y
determina si hay o no conexion dependiendo del resultado.

curl -s -I -L:
    -s => silent. No muestra ningun mensaje, error o barra de progreso
    -I => solo coje la cabecera
    -L => especificamos la url que tiene que ser del tipo http
grep ^HTTP:
    cogemos unicamente la linea que empieza por HTTP
awk '{print $2}':
    obtenemos el segundo valor de la linea
COMMENT

function enviarCorreo {
    mail -s "Reporte del CNE $strFecha" $strCorreo < $strLog
}

strCorreo=`cat /var/tmp/correo-enviar`
strLog="/var/tmp/CNE-reporte.log"
#url="http://goe.cantv.com.ve";
url="http://goe.cantv.com.ve/proyectos/goe/login.php?";
strFecha=`date`
echo "" > $strLog

result=$(curl -s -I -L $url | grep ^HTTP | awk '{print $2}'); 

if [ "$result" = "200" ]; then
    echo "Buenas" | tee -a $strLog
    echo "" | tee -a $strLog
    echo "Hay conexion con la pagina http://goe.cantv.com.ve/proyectos/goe/login.php?" | tee -a $strLog
    result1=`(time -p wget -P /tmp -pq http://goe.cantv.com.ve/proyectos/goe/login.php? --connect-timeout=10 -t 1) 2>&1 | grep real | sed "s/[real\.*]//g" | xargs echo 10 \* | exec bc` 
    echo "La pagina respondio en: $result1 milisegundos." | tee -a $strLog
    if [ $result1 -gt 20000 ]; then
        echo "El tiempo de respuesta esta por encima del umbral que es de 20000 milisegundos." | tee -a $strLog
    fi
    echo $strFecha | tee -a $strLog
    echo "" | tee -a $strLog
    echo "Atte." | tee -a $strLog
    echo "Soporte Middleware" | tee -a $strLog
    echo "Operaciones TI Centralizadas" | tee -a $strLog
    echo "Coordinacion de Soporte Middleware y Base de Datos" | tee -a $strLog
    echo "GGTO - GOC - Gerencia Operaciones TI Centralizadas" | tee -a $strLog
    echo "Telf. Guardia: 0416-6222352" | tee -a $strLog
    echo "Para atencion de solicitudes por favor contactar al Centro de Interaccion Corporativo (0212-5008745)" | tee -a $strLog
   echo "Por favor emitir Agradecimientos, Sugerencias o Quejas por http://escritorio.cantv.net/Reportes/opinion.pl" | tee -a $strLog
else
    echo "Buenas" | tee -a $strLog
    echo "" | tee -a $strLog
    echo "ERROR.!!!!NO hay conexion con la pagina http://goe.cantv.com.ve/proyectos/goe/login.php?" | tee -a $strLog
    echo "" | tee -a $strLog
    echo "Atte." | tee -a $strLog
    echo "Soporte Middleware" | tee -a $strLog
    echo "Operaciones TI Centralizadas" | tee -a $strLog
    echo "Coordinacion de Soporte Middleware y Base de Datos" | tee -a $strLog
    echo "GGTO - GOC - Gerencia Operaciones TI Centralizadas" | tee -a $strLog
    echo "Telf. Guardia: 0416-6222352" | tee -a $strLog
    echo "Para atencion de solicitudes por favor contactar al Centro de Interaccion Corporativo (0212-5008745)" | tee -a $strLog
   echo "Por favor emitir Agradecimientos, Sugerencias o Quejas por http://escritorio.cantv.net/Reportes/opinion.pl" | tee -a $strLog
fi

enviarCorreo
echo "" > $strLog



#(time -p wget -pq http://goe.cantv.com.ve/proyectos/goe/login.php? --connect-timeout=10 -t 1) 2>&1 | grep real | sed "s/[real\.*]//g" | xargs echo 10 \* | exec bc
