#!/bin/bash

#snmpwalk -v1 -c C0mcantvc0r 161.196.189.47 iso.3.6.1.2.1.25.4.2.1.2.1734
#snmpwalk -v1 -c C0mcantvc0r 161.196.189.47 1.3.6.1.4.1.2021.2.1.2
#iso.3.6.1.4.1.2021.2.1.2.1 = STRING: "snmpd"
#iso.3.6.1.4.1.2021.2.1.2.2 = STRING: "syslogd"
#iso.3.6.1.4.1.2021.2.1.2.3 = STRING: "sshd"
#iso.3.6.1.4.1.2021.2.1.2.4 = STRING: "crond"
#iso.3.6.1.4.1.2021.2.1.2.5 = STRING: "ntpd"
#iso.3.6.1.4.1.2021.2.1.2.6 = STRING: "enlinuxpc"
#iso.3.6.1.4.1.2021.2.1.2.7 = STRING: "httpd"
#iso.3.6.1.4.1.2021.2.1.2.8 = STRING: "xinetd"

# snmpwalk -v1 -c C0mcantvc0r 161.196.189.47 iso.3.6.1.4.1.2021.2.1.101
#iso.3.6.1.4.1.2021.2.1.101.1 = ""
#iso.3.6.1.4.1.2021.2.1.101.2 = STRING: "No syslogd process running."
#iso.3.6.1.4.1.2021.2.1.101.3 = ""
#iso.3.6.1.4.1.2021.2.1.101.4 = ""
#iso.3.6.1.4.1.2021.2.1.101.5 = ""
#iso.3.6.1.4.1.2021.2.1.101.6 = ""
#iso.3.6.1.4.1.2021.2.1.101.7 = ""
#iso.3.6.1.4.1.2021.2.1.101.8 = ""

function enviarCorreo {
    mail -s "Reporte de los Servicios CNE $strFecha" $strCorreo < $strLog
}

echo "" > $strLog
strCorreo=`cat /var/tmp/correo-enviar1`
strLog="/var/tmp/CNE-reporte-servicios.log"
#url="http://goe.cantv.com.ve";
strFecha=`date`

echo "Buenas"| tee -a $strLog
echo "" | tee -a $strLog
echo $strFecha | tee -a $strLog
echo "" | tee -a $strLog
echo "Reporte de estatus de los Servicios en los Servidores:" | tee -a $strLog
echo "161.196.189.47 VMLGOEPRO_01(Web Server Administrativo de desarrollo CNE GOR/SGO )" | tee -a $strLog
echo "161.196.189.48 VMLGOEPRO_02 (Web Server Administrativo CNE GOR/SGO )" | tee -a $strLog


### ============================================================================================================== ##
echo "" | tee -a $strLog
echo "" | tee -a $strLog

## Servicio strsnmp
strsnmp=`snmpwalk -v1 -c C0mcantvc0r 161.196.189.47 iso.3.6.1.4.1.2021.2.1.101.1 | awk '{print $3}'`
if [ $strsnmp == "\"\"" ]; then
    echo "161.196.189.47 161.196.189.47 VMLGOEPRO_01(Web Server Administrativo de desarrollo CNE GOR/SGO ) El servicio snmp esta Up" | tee -a $strLog
else
    echo "161.196.189.47 VMLGOEPRO_01(Web Server Administrativo de desarrollo CNE GOR/SGO ) El servicio snmp esta DOWN" | tee -a $strLog
fi
## Servicio syslogd
syslogd=`snmpwalk -v1 -c C0mcantvc0r 161.196.189.47 iso.3.6.1.4.1.2021.2.1.101.2 | awk '{print $3}'`
if [ $syslogd == "\"\"" ]; then
    echo "161.196.189.47 VMLGOEPRO_01(Web Server Administrativo de desarrollo CNE GOR/SGO ) El servicio syslogd esta Up" | tee -a $strLog
else
    echo "161.196.189.47 VMLGOEPRO_01(Web Server Administrativo de desarrollo CNE GOR/SGO ) El servicio syslogd esta DOWN" | tee -a $strLog
fi
## Servicio sshd
sshd=`snmpwalk -v1 -c C0mcantvc0r 161.196.189.47 iso.3.6.1.4.1.2021.2.1.101.3 | awk '{print $3}'`
if [ $sshd == "\"\"" ]; then
    echo "161.196.189.47 VMLGOEPRO_01(Web Server Administrativo de desarrollo CNE GOR/SGO ) El servicio sshd esta Up" | tee -a $strLog
else
    echo "161.196.189.47 VMLGOEPRO_01(Web Server Administrativo de desarrollo CNE GOR/SGO ) El servicio sshd esta DOWN" | tee -a $strLog
fi
## Servicio crond
crond=`snmpwalk -v1 -c C0mcantvc0r 161.196.189.47 iso.3.6.1.4.1.2021.2.1.101.4 | awk '{print $3}'`
if [ $crond == "\"\"" ]; then
    echo "161.196.189.47 VMLGOEPRO_01(Web Server Administrativo de desarrollo CNE GOR/SGO ) El servicio crond esta Up" | tee -a $strLog
else
    echo "161.196.189.47 VMLGOEPRO_01(Web Server Administrativo de desarrollo CNE GOR/SGO ) El servicio crond esta DOWN" | tee -a $strLog
fi
## Servicio ntpd
ntpd=`snmpwalk -v1 -c C0mcantvc0r 161.196.189.47 iso.3.6.1.4.1.2021.2.1.101.5 | awk '{print $3}'`
if [ $ntpd == "\"\"" ]; then
    echo "161.196.189.47 VMLGOEPRO_01(Web Server Administrativo de desarrollo CNE GOR/SGO ) El servicio ntpd esta Up" | tee -a $strLog
else
    echo "161.196.189.47 VMLGOEPRO_01(Web Server Administrativo de desarrollo CNE GOR/SGO ) El servicio ntpd esta DOWN" | tee -a $strLog
fi
## Servicio enlinuxpc
enlinuxpc=`snmpwalk -v1 -c C0mcantvc0r 161.196.189.47 iso.3.6.1.4.1.2021.2.1.101.6 | awk '{print $3}'`
if [ $enlinuxpc == "\"\"" ]; then
    echo "161.196.189.47 VMLGOEPRO_01(Web Server Administrativo de desarrollo CNE GOR/SGO ) El servicio enlinuxpc esta Up" | tee -a $strLog
else
    echo "161.196.189.47 VMLGOEPRO_01(Web Server Administrativo de desarrollo CNE GOR/SGO ) El servicio enlinuxpc esta DOWN" | tee -a $strLog
fi
## Servicio httpd
#httpd=`snmpwalk -v1 -c C0mcantvc0r 161.196.189.47 iso.3.6.1.4.1.2021.2.1.101.7 | awk '{print $3}'`
#if [ $httpd == "\"\"" ]; then
#    echo "161.196.189.47 VMLGOEPRO_01(Web Server Administrativo de desarrollo CNE GOR/SGO ) El servicio httpd esta Up" | tee -a $strLog
#else
#    echo "161.196.189.47 VMLGOEPRO_01(Web Server Administrativo de desarrollo CNE GOR/SGO ) El servicio httpd esta DOWN" | tee -a $strLog
#fi
## Servicio xinetd
#xinetd=`snmpwalk -v1 -c C0mcantvc0r 161.196.189.47 iso.3.6.1.4.1.2021.2.1.101.8 | awk '{print $3}'`
#if [ $enlinuxpc == "\"\"" ]; then
#    echo "161.196.189.47 VMLGOEPRO_01(Web Server Administrativo de desarrollo CNE GOR/SGO ) El servicio xinetd esta Up" | tee -a $strLog
#else
#    echo "161.196.189.47 VMLGOEPRO_01(Web Server Administrativo de desarrollo CNE GOR/SGO ) El servicio xinetd esta DOWN" | tee -a $strLog
#fi
### ============================================================================================================== ##
echo "" | tee -a $strLog
echo "" | tee -a $strLog
## Servicio strsnmp
strsnmp=`snmpwalk -v1 -c C0mcantvc0r 161.196.189.48 iso.3.6.1.4.1.2021.2.1.101.1 | awk '{print $3}'`
if [ $strsnmp == "\"\"" ]; then
    echo "161.196.189.48 VMLGOEPRO_02 (Web Server Administrativo CNE GOR/SGO ) El servicio snmp esta Up" | tee -a $strLog
else
    echo "161.196.189.48 VMLGOEPRO_02 (Web Server Administrativo CNE GOR/SGO ) El servicio snmp esta DOWN" | tee -a $strLog
fi
## Servicio syslogd
syslogd=`snmpwalk -v1 -c C0mcantvc0r 161.196.189.48 iso.3.6.1.4.1.2021.2.1.101.2 | awk '{print $3}'`
if [ $syslogd == "\"\"" ]; then
    echo "161.196.189.48 VMLGOEPRO_02 (Web Server Administrativo CNE GOR/SGO ) El servicio syslogd esta Up" | tee -a $strLog
else
    echo "161.196.189.48 VMLGOEPRO_02 (Web Server Administrativo CNE GOR/SGO ) El servicio syslogd esta DOWN" | tee -a $strLog
fi
## Servicio sshd
sshd=`snmpwalk -v1 -c C0mcantvc0r 161.196.189.48 iso.3.6.1.4.1.2021.2.1.101.3 | awk '{print $3}'`
if [ $sshd == "\"\"" ]; then
    echo "161.196.189.48 VMLGOEPRO_02 (Web Server Administrativo CNE GOR/SGO ) El servicio sshd esta Up" | tee -a $strLog
else
    echo "161.196.189.48 VMLGOEPRO_02 (Web Server Administrativo CNE GOR/SGO ) El servicio sshd esta DOWN" | tee -a $strLog
fi
## Servicio crond
crond=`snmpwalk -v1 -c C0mcantvc0r 161.196.189.48 iso.3.6.1.4.1.2021.2.1.101.4 | awk '{print $3}'`
if [ $crond == "\"\"" ]; then
    echo "161.196.189.48 VMLGOEPRO_02 (Web Server Administrativo CNE GOR/SGO ) El servicio crond esta Up" | tee -a $strLog
else
    echo "161.196.189.48 VMLGOEPRO_02 (Web Server Administrativo CNE GOR/SGO ) El servicio crond esta DOWN" | tee -a $strLog
fi
## Servicio ntpd
ntpd=`snmpwalk -v1 -c C0mcantvc0r 161.196.189.48 iso.3.6.1.4.1.2021.2.1.101.5 | awk '{print $3}'`
if [ $ntpd == "\"\"" ]; then
    echo "161.196.189.48 VMLGOEPRO_02 (Web Server Administrativo CNE GOR/SGO ) El servicio ntpd esta Up" | tee -a $strLog
else
    echo "161.196.189.48 VMLGOEPRO_02 (Web Server Administrativo CNE GOR/SGO ) El servicio ntpd esta DOWN" | tee -a $strLog
fi
## Servicio enlinuxpc
enlinuxpc=`snmpwalk -v1 -c C0mcantvc0r 161.196.189.48 iso.3.6.1.4.1.2021.2.1.101.6 | awk '{print $3}'`
if [ $enlinuxpc == "\"\"" ]; then
    echo "161.196.189.48 VMLGOEPRO_02 (Web Server Administrativo CNE GOR/SGO ) El servicio enlinuxpc esta Up" | tee -a $strLog
else
    echo "161.196.189.48 VMLGOEPRO_02 (Web Server Administrativo CNE GOR/SGO ) El servicio enlinuxpc esta DOWN" | tee -a $strLog
fi
## Servicio httpd
httpd=`snmpwalk -v1 -c C0mcantvc0r 161.196.189.48 iso.3.6.1.4.1.2021.2.1.101.7 | awk '{print $3}'`
if [ $httpd == "\"\"" ]; then
    echo "161.196.189.48 VMLGOEPRO_02 (Web Server Administrativo CNE GOR/SGO ) El servicio httpd esta Up" | tee -a $strLog
else
    echo "161.196.189.48 VMLGOEPRO_02 (Web Server Administrativo CNE GOR/SGO ) El servicio httpd esta DOWN" | tee -a $strLog
fi
## Servicio xinetd
xinetd=`snmpwalk -v1 -c C0mcantvc0r 161.196.189.48 iso.3.6.1.4.1.2021.2.1.101.8 | awk '{print $3}'`
if [ $enlinuxpc == "\"\"" ]; then
    echo "161.196.189.48 VMLGOEPRO_02 (Web Server Administrativo CNE GOR/SGO ) El servicio xinetd esta Up" | tee -a $strLog
else
    echo "161.196.189.48 VMLGOEPRO_02 (Web Server Administrativo CNE GOR/SGO ) El servicio xinetd esta DOWN" | tee -a $strLog
fi


    echo "" | tee -a $strLog
    echo "Atte." | tee -a $strLog
    echo "Soporte Middleware" | tee -a $strLog
    echo "Operaciones TI Centralizadas" | tee -a $strLog
    echo "Coordinacion de Soporte Middleware y Base de Datos" | tee -a $strLog
    echo "GGTO - GOC - Gerencia Operaciones TI Centralizadas" | tee -a $strLog
    echo "Telf. Guardia: 0416-6222352" | tee -a $strLog
    echo "Para atencion de solicitudes por favor contactar al Centro de Interaccion Corporativo (0212-5008745)" | tee -a $strLog
   echo "Por favor emitir Agradecimientos, Sugerencias o Quejas por http://escritorio.cantv.net/Reportes/opinion.pl" | tee -a $strLog

enviarCorreo
echo "" > $strLog

