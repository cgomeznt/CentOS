Configurar NTP
==============

Configuración del Server
+++++++++++++++++++++++++++++

Instalar ntp server.::

	# yum install -y ntp ntpdate

Configurando el firewalld.::

	# firewall-cmd --permanent --add-port=123/udp
	# firewall-cmd --reload

Configurar ntp server.::

	# sed -i 's/#restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap/restrict 192.168.56.0 mask 255.255.255.0 nomodify notrap/' /etc/ntp.conf
	# sed -i 's/server 0.centos.pool.ntp.org iburst/server ntp1.jst.mfeed.ad.jp iburst/' /etc/ntp.conf
	# sed -i 's/server 1.centos.pool.ntp.org iburst/server ntp2.jst.mfeed.ad.jp iburst/' /etc/ntp.conf
	# sed -i 's/server 2.centos.pool.ntp.org iburst/server ntp3.jst.mfeed.ad.jp iburst/' /etc/ntp.conf
	# sed -i 's/server 3.centos.pool.ntp.org iburst/# server 3.centos.pool.ntp.org iburst/' /etc/ntp.conf

Iniciando ntp server.::

	# systemctl start ntpd
	# systemctl enable ntpd

Verificando ntp.::

	# ntpq -p

Configurando el reloj.::

	# ntpdate -u localhost


Configuración de los clientes
+++++++++++++++++++++++++++++

En los clientes lo unico que se debe hacer es ubicar el archivo "/etc/ntp.conf" y eliminamos las lineas en donde estan los servers y agregamos nuestro nuevo server.::

	# Use public servers from the pool.ntp.org project.
	# Please consider joining the pool (http://www.pool.ntp.org/join.html).
	server 200.194.21.21



