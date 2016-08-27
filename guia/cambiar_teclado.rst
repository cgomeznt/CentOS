CAMBIAR EL IDIOMA DEL TECLADO EN CENTOS
=======================================

vi /etc/sysconfig/keyboard

Cambiamos las lineas que nos interesan.::

	KEYTABLE=”es”
	MODEL=”pc105+inet”
	LAYOUT=”es”
	KEYBOARDTYPE=”pc”

Reiniciar para que tenga efecto.

Sin reiniciar, con el siguiente comando.::

	loadkeys es

O::

	loadkeys /lib/kbd/keymaps/i386/qwerty/es.map.gz
