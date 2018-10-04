Como instalar VNC Server
===========================

Primero vemos si ya esta el paquete y sino lo instalamos y debemos tener las X instaladas.::

	# rpm -qa | grep vnc

	# yum search vnc

	# yum install tigervnc-server.x86_64


Creamos los usuarios o podemos utilizar los que ya existan.::

	# useradd oracle
	# useradd cgomez
	# useradd zabbix


Editamos el archivo de configuración del VNC::

	# vi /etc/sysconfig/vncservers

	VNCSERVERS="1:oracle 2:cgomez 3:zabbix"
	VNCSERVERARGS[1]="-geometry 640x480"
	VNCSERVERARGS[2]="-geometry 1024x768"
	VNCSERVERARGS[3]="-geometry 800x600"

Oracle utilizara la configuración de 640x480, cgomez 1024x768 y zabbix 700x600


Ahora vamos a cada perfil de usuario y le vamos a crear el password que utilizara para que el vnc-client pueda establecer la conexión, preferiblemente utilizamos la misma clave del login.::

	# su - oracle
	$ vncpasswd
	cd .vnc
	[.vnc]$ ls
	passwd
	[.vnc]$ exit

	# su - cgomez
	$ vncpasswd
	cd .vnc
	[.vnc]$ ls
	passwd
	[.vnc]$ exit

	# su - zabbix
	$ vncpasswd
	cd .vnc
	[.vnc]$ ls
	passwd
	[.vnc]$ exit

Iniciamos el servicio de VNC server.::

	# /sbin/service   vncserver start
	# /sbin/service   vncserver stop
	# /sbin/service   vncserver status
	# /sbin/service   vncserver start
	# /sbin/chkconfig vncserver on


Verificamos desde un cliente.::

	# vncviewer 192.168.0.4:1


.. figure:: ../images/vnc/01.png



