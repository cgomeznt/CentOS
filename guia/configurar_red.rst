Configurar Red
===============

Lo primero que nos encontramos al haber realizado una instalación de Centos es que no hay conexión a internet. Para ello hemos de activar la tarjeta de red y configurarla y esto se hace en la siguiente ruta::

	/etc/sysconfig/network-scritps

Aquí debemos tener como mínimo 2 ficheros con el siguiente nombre::

	ifcfg-eth0

	ifcfg-lo

Dentro de cada uno de estos ficheros tenemos la configuracion ip de la tarjeta de red y algunas opciones mas. Procedemos a editar el fichero ifcfg-eth0 con el comando vi (nano no viene instalado por defecto en Centos).

IP Estatica
-----------
::

	DEVICE="eth0"
	HWADDR="00:1C:C0:5E:DA:7B"
	NM_CONTROLLED="yes"
	ONBOOT="yes"
	BOOTPROTO="static"

	IPADDR=10.10.1.11
	NETMASK=255.255.255.0
	GATEWAY=10.10.1.1
	TYPE=Ethernet


HWADDR Es la mac de la tarjeta de red que vamos a configurar.
ONBOOT Es para decirle al sistema que encienda la tarjeta de red al inicio de este.
BOOTPROTO Podemos indicarle static, none , dhcp dependiendo la configuracion que deseemos.
Lo que hay debajo es directamente los comandos necesarios para decirle que ip, mascara y puerta de enlace queremos que tenga nuestra tarjeta de red.
 
IP Dinámica
-----------

Si por ejemplo la quisiéramos configurar como DHCP tan solo seria necesario indicar lo siguiente en el archivo de configuración.::

	DEVICE="eth0"
	HWADDR="00:1C:C0:5E:DA:7B"
	NM_CONTROLLED="yes"
	ONBOOT="yes"
	BOOTPROTO="dhcp"
 
Configurando servidores DNS
----------------------------

Como en cualquier otro sistema Linux podemos configurar las DNS en el archivo /etc/resolv.conf::

	nameserver 8.8.8.8
	nameserver 8.8.8.4

añadiendo tantos servidores DNS como queramos. En este caso las ips corresponden a los servidores DNS de Google.
 
Activando las tarjetas de red
-------------------------------

Por último vamos a activar las tarjetas de red y que vuelvan a cargar la configuración que le acabamos de indicar. Si queremos reiniciar todo el servicio de red podemos realizar el siguiente comando.::

/etc/init.d/network restart

Pero si por algun motivo hemos añadido una tarjeta de red adicional y no queremos tener que reiniciar ambas, podemos reiniciar solamente una tarjeta de red, suponiendo que vamos a reiniciar eth1.::

	ifdown eth1

	ifup eth1

Si todo ha funcionado correctamente, veremos un mensaje que nos indica que ha ido bien. Aun así podemos revisar con ifconfig si ha asociado una ip a la tarjeta de red.
 
El dispositivo eth0 no parece estar presente
---------------------------------------------

Yo ya tenia el servidor montado y ahora le he añadido una nueva tarjeta de red (adicional) y aunque configuro el archivo, no obtengo conexión por esa tarjeta nueva.
Da un error El dispositivo eth0 no parece estar presente, retrasando la inicializacion
Primero vamos a revisar si nuestro sistema Centos ha detectado la tarjeta de red, para ello hacemos uso de lspci ( yum install pciutils ) y revisamos si nos muestra la tarjeta de red.::

	# lspci
	00:00.0 Host bridge: Intel Corporation 82945G/GZ/P/PL Memory Controller Hub (rev 02)
	00:02.0 VGA compatible controller: Intel Corporation 82945G/GZ Integrated Graphics Controller (rev 02)
	00:1b.0 Audio device: Intel Corporation NM10/ICH7 Family High Definition Audio Controller (rev 01)
	00:1c.0 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 1 (rev 01)
	00:1c.2 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 3 (rev 01)
	00:1c.3 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 4 (rev 01)
	00:1d.0 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #1 (rev 01)
	00:1d.1 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #2 (rev 01)
	00:1d.2 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #3 (rev 01)
	00:1d.3 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #4 (rev 01)
	00:1d.7 USB controller: Intel Corporation NM10/ICH7 Family USB2 EHCI Controller (rev 01)
	00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
	00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface Bridge (rev 01)
	00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 01)
	00:1f.2 IDE interface: Intel Corporation NM10/ICH7 Family SATA Controller [IDE mode] (rev 01)
	00:1f.3 SMBus: Intel Corporation NM10/ICH7 Family SMBus Controller (rev 01)
	01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
	04:00.0 Ethernet controller: VIA Technologies, Inc. VT6105/VT6106S [Rhine-III] (rev 86)

Como podemos ver, encontramos dos Ethernet controller, la nueva que hemos añadido en este caso es la Via Technologies. Tambien podemos revisarlo usando el comando.::

	# ls /sys/class/net
	eth0  eth1  lo

A continuacion editamos el archivo /etc/udev/rules.d/70-persistent-net.rules y revisamos que la MAC de la tarjeta de red y el nombre esten coherentes con el archivo ifcfg-eth que tenemos en /etc/sysconfig/network-scripts.::

	# This file was automatically generated by the /lib/udev/write_net_rules
	# program, run by the persistent-net-generator.rules rules file.
	#
	# You can modify it, as long as you keep each rule on a single
	# line, and change only the value of the NAME= key.

	# PCI device 0x10ec:0x8136 (r8169)
	SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:1c:c0:5e:da:7b", ATTR{type}=="1", KERNEL=="eth*", NAME="eth0"

	# PCI device 0x10ec:0x8139 (8139too)
	SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:40:95:30:19:a5", ATTR{type}=="1", KERNEL=="eth*", NAME="eth1"

	# PCI device 0x1106:0x3106 (via-rhine)
	SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:50:fc:8b:8d:f3", ATTR{type}=="1", KERNEL=="eth*", NAME="eth2"

En mi caso habia detectado otra tarjeta de red (alguna que probe anteriormente) y le habia puesto el nombre de eth1 , pero claro esta tarjeta ya no existia conectada en el sistema. Por mi parte la solucion ha venido de cambiar el NAME de la tarjeta eth2 a eth1 y comentar la tarjeta que no esta conectada al sistema.::

	# This file was automatically generated by the /lib/udev/write_net_rules
	# program, run by the persistent-net-generator.rules rules file.
	#
	# You can modify it, as long as you keep each rule on a single
	# line, and change only the value of the NAME= key.

	# PCI device 0x10ec:0x8136 (r8169)
	SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:1c:c0:5e:da:7b", ATTR{type}=="1", KERNEL=="eth*", NAME="eth0"

	# PCI device 0x10ec:0x8139 (8139too)
	#SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:40:95:30:19:a5", ATTR{type}=="1", KERNEL=="eth*", NAME="eth2"

	# PCI device 0x1106:0x3106 (via-rhine)
	SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:50:fc:8b:8d:f3", ATTR{type}=="1", KERNEL=="eth*", NAME="eth1"

Por último revisamos que en el archivo ifcfg-eth1 la mac de la tarjeta de red coincida, si no al intentar levantar la conexión nos dará otro error. Podemos saber también la MAC de la tarjeta conectada mediante el comando ethtool -P eth1, que nos devolverá la direccion MAC de la tarjeta de red.::

	DEVICE="eth1"
	HWADDR="00:50:fc:8b:8d:f3"
	NM_CONTROLLED="yes"
	ONBOOT="yes"
	BOOTPROTO="dhcp"

 
Si hemos configurado todo correctamente, ya podremos tener internet por ambas tarjetas de red. Ahora podremos dedicar el tiempo con el IPTables para configurar el Firewall y el SElinux.
