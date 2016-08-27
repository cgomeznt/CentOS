CAMBIAR EL DNS EN CENTOS
========================

Para cambiar el DNS editamos el archivo /etc/resolv.conf y agregamos o modificamos las líneas con las direcciones IP de los servidores DNS que necesitemos. A continuación se muestra este archivo::

	#dominio de nuestra máquina
	search home.local
	#DNS principal
	nameserver 8.8.8.8
	#DNS secundario
	nameserver 8.8.8.4

Si sólo cambiamos el DNS no es necesario que reiniciemos el servicio de red, el cambio se aplica en automático.
