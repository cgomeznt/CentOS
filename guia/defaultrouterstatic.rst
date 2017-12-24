Configurar Default Router y Static Router
=========================================

En este ejemplo tenemos tres adaptadores de red
* eth0
* eth1
* eth2

La eth0 tendra el default Gateway en el archivo de configuracion ifcfg-eth0 y los demás archivo ifcfg-eth1 y ifcfg-eth2 solo las configuraciones pero sin Gateway.

Se creara un route-eth1 y route-eth2 para crear las rutas estaticas.

Configuramos el adaptadores de RED eth0.::

	# vi ifcfg-eth0
		DEVICE=eth0
		BOOTPROTO=none
		HWADDR=00:50:56:8F:3D:64
		ONBOOT=yes
		NETMASK=255.255.255.0
		IPADDR=172.16.72.22
		GATEWAY=172.16.72.1
		TYPE=Ethernet
		USERCTL=no
		IPV6INIT=no
		PEERDNS=yes

Configuramos el adaptador de RED eth1.::

	# vi ifcfg-eth1
		DEVICE=eth1
		BOOTPROTO=none
		ONBOOT=no
		HWADDR=00:50:56:8f:09:e3
		NETMASK=255.255.255.0
		IPADDR=10.124.2.91
		TYPE=Ethernet
		USERCTL=no
		IPV6INIT=no
		PEERDNS=yes

Configuaramos el adaptador de RED eth2.::

	# vi ifcfg-eth2
		DEVICE=eth2
		BOOTPROTO=none
		ONBOOT=no
		HWADDR=00:50:56:95:3a:46
		NETMASK=255.255.255.0
		IPADDR=10.124.3.91
		TYPE=Ethernet
		USERCTL=no
		IPV6INIT=no
		PEERDNS=yes

Iniciamos los adaptadores.::

	# ifup eth0 eth1 eth2

Consultamos los adaptadores.::

	# ifconfig
	eth0      Link encap:Ethernet  HWaddr 00:50:56:8F:3D:64
		      inet addr:172.16.72.22  Bcast:172.16.72.255  Mask:255.255.255.0
		      inet6 addr: fe80::250:56ff:fe8f:3d64/64 Scope:Link
		      UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
		      RX packets:118509 errors:0 dropped:0 overruns:0 frame:0
		      TX packets:134419 errors:0 dropped:0 overruns:0 carrier:0
		      collisions:0 txqueuelen:1000
		      RX bytes:22316485 (21.2 MiB)  TX bytes:72892001 (69.5 MiB)
		      Interrupt:59 Base address:0x2000

	eth1      Link encap:Ethernet  HWaddr 00:50:56:8F:09:E3
		      inet addr:10.124.2.91  Bcast:10.124.2.255  Mask:255.255.255.0
		      inet6 addr: fe80::250:56ff:fe8f:9e3/64 Scope:Link
		      UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
		      RX packets:19 errors:0 dropped:0 overruns:0 frame:0
		      TX packets:43 errors:0 dropped:0 overruns:0 carrier:0
		      collisions:0 txqueuelen:1000
		      RX bytes:1388 (1.3 KiB)  TX bytes:6686 (6.5 KiB)
		      Interrupt:67 Base address:0x2080

	eth2      Link encap:Ethernet  HWaddr 00:50:56:95:3A:46
		      inet addr:10.124.3.91  Bcast:10.124.3.255  Mask:255.255.255.0
		      inet6 addr: fe80::250:56ff:fe95:3a46/64 Scope:Link
		      UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
		      RX packets:11 errors:0 dropped:0 overruns:0 frame:0
		      TX packets:38 errors:0 dropped:0 overruns:0 carrier:0
		      collisions:0 txqueuelen:1000
		      RX bytes:888 (888.0 b)  TX bytes:6170 (6.0 KiB)

	lo        Link encap:Local Loopback
		      inet addr:127.0.0.1  Mask:255.0.0.0
		      inet6 addr: ::1/128 Scope:Host
		      UP LOOPBACK RUNNING  MTU:16436  Metric:1
		      RX packets:50452 errors:0 dropped:0 overruns:0 frame:0
		      TX packets:50452 errors:0 dropped:0 overruns:0 carrier:0
		      collisions:0 txqueuelen:0
		      RX bytes:8032429 (7.6 MiB)  TX bytes:8032429 (7.6 MiB)

No se requiere configurar las rutas estaticas de eth0 motivado que tiene el dafault Gateway.

Configuramos las rutas estaticas de eth1.::

	# vi route-eth1
		10.124.2.0/24 via 10.124.2.1 dev eth1

Configuramos las rutas estaticas de eth2.::

	# vi route-eth2
		10.124.3.0/24 via 10.124.3.1 dev eth2
		10.140.0.0/24 via 10.124.3.1 dev eth2
		192.168.110.0/24 via 10.124.3.1 dev eth2
		10.133.0.54 via 10.124.3.1 dev eth2
		10.133.0.53 via 10.124.3.1 dev eth2
		10.140.8.0/24 via 10.124.3.1 dev eth2
		192.168.201.152/29 via 10.124.3.1 dev eth2


Reiniciamos los adaptadores.::

	# ifdown eth1
	# ifup eth1
	# ifdown eth2
	# ifup eth2

Consultamos las rutas configuradas.::

	# route
		Kernel IP routing table
		Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
		10.124.3.0      *               255.255.255.0   U     0      0        0 eth2
		10.140.0.0      10.124.3.1      255.255.255.0   U     0      0        0 eth2
		192.168.110.0   10.124.3.1      255.255.255.0   U     0      0        0 eth2
		10.133.0.54     10.124.3.1      255.255.255.0   U     0      0        0 eth2
		10.133.0.53     10.124.3.1      255.255.255.0   U     0      0        0 eth2
		10.124.2.0      *               255.255.255.0   U     0      0        0 eth1
		172.16.72.0     *               255.255.255.0   U     0      0        0 eth0
		default         172.16.72.1     0.0.0.0         UG    0      0        0 eth0




