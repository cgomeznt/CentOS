Configurar Default Gateway


Configurar un default gateway para todos los adaptadores

De forma temporal::

	# route add default gw 
	# route del default gw 

 
Hay varias formas de configurar el  TCP/IP. La forma mas simple para un default gateway es modificar el /etc/sysconfig/network::

	# vi /etc/sysconfig/network

	NETWORKING=yes
	NETWORKING_IPV6=yes
	HOSTNAME=home.local
	GATEWAY=10.10.0.1

Reiniciamos el servicio::
	# /etc/init.d/networking restart

Detalle de los cada item
-------------------------
NETWORKING=<value>, where <value> is one of the following boolean values:
yes — Networking should be configured.
no — Networking should not be configured.
HOSTNAME=<value>, where <value> should be the Fully Qualified Domain Name (FQDN), such as hostname.expample.com, but can be whatever hostname is necessary.
GATEWAY=<value>, where <value> is the IP address of the network's gateway.
GATEWAYDEV=<value>, where <value> is the gateway device, such as eth0. Configure this option if you have multiple interfaces on the same subnet, and require one of those interfaces to be the preferred route to the default gateway.
NISDOMAIN=<value>, where <value> is the NIS domain name.
NOZEROCONF=<value>, where setting <value> to true disables the zeroconf route.




