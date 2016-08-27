Configurar Static Routes
========================

En Red Hat/Centos /etc/sysconfig/network-scripts/route-eth0


Mostrar la tabla de enrutamiento.::

	# ip route show

	192.168.2.0/24 dev eth1 proto kernel  scope link  src 192.168.2.1
	192.168.1.0/24 dev eth0  proto kernel  scope link  src 192.168.1.2
	default via 192.168.1.254 dev eth0

Agregar static route en la linea de comando:
ip route add {NETWORK} via {IP} dev {DEVICE}
Ejemplo network 192.168.55.0/24 available via 192.168.1.254::

	# ip route add 192.168.55.0/24 via 192.168.1.254 dev eth1

Alternativa de forma antigua::

	# route add -net 192.168.55.0 netmask 255.255.255.0 gw 192.168.1.254 dev eth1

Para dejar fija las static route
---------------------------------

Requerimos editar /etc/sysconfig/network-scripts/route-eth0 define la static routes for eth0 interface::

	# cat /etc/sysconfig/network-scripts/route-eth0

	GATEWAY0=192.168.1.254
	NETMASK0=255.255.255.0
	ADDRESS0=192.168.55.0
	GATEWAY1=10.164.234.112
	NETMASK1= 255.255.255.240
	ADDRESS1=10.164.234.132

Definimos static routing para la network 10.0.0.0/8 via 10.9.38.65 router.
Editamos /etc/sysconfig/network-scripts/route-eth0::

	# vi /etc/sysconfig/network-scripts/route-eth0

	Agregamos
	10.0.0.0/8 via 10.9.38.65

Reiniciamos el servicio::

	# service network restart

Verificamos la tabla de enrutamiento::

	# route -n


