#!/bin/sh
 
#########################################################################
# Por: Carlos Gomez Gomez
# https://github.com/cgomeznt/
##########################################################################

# Deben habilitar en este link que dicha cuenta Permitir el acceso de aplicaciones menos seguras
# https://myaccount.google.com/lesssecureapps

# servidor de salida
FROM_EMAIL_ADDRESS="rapid.pagos@gmail.com"
FRIENDLY_NAME="Rapid Pago"
EMAIL_ACCOUNT_PASSWORD="America21"
SERVER_SMTP="smtp://smtp.gmail.com:587"
 
# destinatario del mensaje
TO_EMAIL_ADDRESS="cgomeznt@gmail.com,efrhen.isturdes@gmail.com"
 
EMAIL_SUBJECT="prueba para envio de correo con mailx desde consola"

# todo lo que pongamos en el echo, sera el contenido del correo
echo -e "
Buenas.

Aqui se coloca el cuerpo del correo

continua el cuerpo del correo


Saludos...;) " | mailx -v -s "$EMAIL_SUBJECT" \
-S smtp-use-starttls \
-S ssl-verify=ignore \
-S smtp-auth=login \
-S smtp=$SERVER_SMTP \
-S from="$FROM_EMAIL_ADDRESS($FRIENDLY_NAME)" \
-S smtp-auth-user=$FROM_EMAIL_ADDRESS \
-S smtp-auth-password=$EMAIL_ACCOUNT_PASSWORD \
-S nss-config-dir="/etc/pki/nssdb/" \
$TO_EMAIL_ADDRESS

