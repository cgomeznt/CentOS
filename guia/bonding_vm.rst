GUIDE: Oracle VM VirtualBox and Oracle Linux NIC bonding
===========================================================
 
The following  is provided in the hope that it might be useful. If you wish to use it for the purpose of reference, presentation or education, please include the link or information to this forum posting. Thank you!
 
What is Linux network interface bonding? Simply put, the Linux system provides a kernel driver, which can create a logical network device (bond) using 2 or more Network Interface Controllers (NIC) to accomplish link-aggregation and adapter fault-tolerance. For more information, please see the Deployment Guide at https://linux.oracle.com/documentation/

The channel bonding interface supports several modes of operation. In a typical active-backup set up for fault-tolerance, the system performs MII-based health monitoring of the network interface slaves (eth0, eth1) and assigns them according to bond options and interface availability. In active-backup mode (mode 1), only the current active network device is seen externally.

Linux bonding for fault-tolerance under Oracle VM VirtualBox does not seem to function as advertised. Searching the Internet for more information shows that other people have tried to set up Linux bonding using various virtualization products, virtual host network adapter and bonding options, but without success.

It appears the management of Media Access Control addresses (MAC) interferes with internal routing methods between the host and the virtual machine guest. Using the modinfo bonding command (fig. 1) shows a listing of available parameters for the bonding kernel module. The fail_over_mac parameter addresses the Mac address issue in VirtualBox.
 
::

	# modinfo bonding
	filename:       /lib/modules/2.6.39-400.17.1.el6uek.x86_64
		            /kernel/drivers/net/bonding/bonding.ko
	parm:           fail_over_mac:For active-backup, 
		            do not set all slaves to the same MAC; 
		            0 for none (default), 1 for active, 2 for follow (charp)

Configuration Example
------------------------

Virtualization Product: Oracle VM VirtualBox 4.2.10
VM Guest OS: Oracle Linux 6.4 (x64)

VM adapter settings: Bridged Adapter, Paravirtualized Network (virtio-net)

Adapter1 (eth0): 080027436617, en0, Ethernet 1
Adapter2 (eth1): 08002708F36A, en0, Ethernet 1

Note: If you wish to reset the network adapter names and MAC addresses used by the Oracle Linux guest system, erase the content of /etc/udev/rules.d/70-persistent-net.rules and restart the virtual machine.

1. Create or modify the following configuration files:
------------------------------------------------------
 ::

	/etc/modprobe.d/bonding-eth0_eth1.conf
	alias bond0 bonding
	 
	/etc/sysconfig/network-scripts/ifcfg-bond0
	DEVICE=bond0
	IPADDR=10.0.2.12
	NETMASK=255.0.0.0
	GATEWAY=10.0.0.138
	DNS1=10.0.0.138
	DNS2=8.8.8.8
	ONBOOT=yes
	BOOTPROTO=none
	USERCTL=no
	BONDING_OPTS="mode=1 miimon=100 fail_over_mac=1"
	 
	/etc/sysconfig/network-scripts/ifcfg-eth0
	DEVICE=eth0
	BOOTPROTO=none
	ONBOOT=yes
	MASTER=bond0
	SLAVE=yes
	USERCTL=no
	 
	/etc/sysconfig/network-scripts/ifcfg-eth1
	DEVICE=eth1 
	BOOTPROTO=none
	ONBOOT=yes
	MASTER=bond0
	SLAVE=yes
	USERCTL=no
 
2. Restart the system or network services (root):
-------------------------------------------------
 
::

	# service network restart
 

Configuration Test
-------------------
 
Enter the following commands as user root to verify proper operation of NIC bonding::
 

	# tail /var/log/messages
	bond0: setting mode to active-backup (1).
	bond0: Setting MII monitoring interval to 100.
	bond0: Setting fail_over_mac to active (1).
	bond0: Adding slave eth0.
	bond0: making interface eth0 the new active one.
	bond0: first active interface up!
	bond0: enslaving eth0 as an active interface with an up link.
	bond0: Adding slave eth1.
	bond0: enslaving eth1 as a backup interface with an up link.
 
::

	# ifconfig
	bond0     Link encap:Ethernet  HWaddr 08:00:27:43:66:17  
		      inet addr:10.0.2.12  Bcast:10.255.255.255  Mask:255.0.0.0
		      inet6 addr: fe80::a00:27ff:fe43:6617/64 Scope:Link
		      UP BROADCAST RUNNING MASTER MULTICAST  MTU:1500  Metric:1

	eth0      Link encap:Ethernet  HWaddr 08:00:27:43:66:17  
		      UP BROADCAST RUNNING SLAVE MULTICAST  MTU:1500  Metric:1

	eth1      Link encap:Ethernet  HWaddr 08:00:27:08:F3:6A  
		      UP BROADCAST RUNNING SLAVE MULTICAST  MTU:1500  Metric:1
 
::

	# netstat -rn
	Kernel IP routing table
	Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
	0.0.0.0         10.0.0.138      0.0.0.0         UG        0 0          0 bond0
	10.0.0.0        0.0.0.0         255.0.0.0       U         0 0          0 bond0
	169.254.0.0     0.0.0.0         255.255.0.0     U         0 0          0 bond0
 
::

	# ifconfig eth0 down
	 
	# tail /var/log/messages
	bond0: link status definitely down for interface eth0, disabling it
	bond0: making interface eth1 the new active one.
 
	# ifconfig
	bond0     Link encap:Ethernet  HWaddr 08:00:27:08:F3:6A  
		      inet addr:10.0.2.12  Bcast:10.255.255.255  Mask:255.0.0.0
		      inet6 addr: fe80::a00:27ff:fe43:6617/64 Scope:Link
		      UP BROADCAST RUNNING MASTER MULTICAST  MTU:1500  Metric:1

	eth1      Link encap:Ethernet  HWaddr 08:00:27:08:F3:6A  
		      UP BROADCAST RUNNING SLAVE MULTICAST  MTU:1500  Metric:1
 
::

	# ifconfig eth0 up
	 
	# ifconfig eth1 down
	 
	# tail /var/log/messages
	bond0: link status definitely up for interface eth0, 4294967295 Mbps full duplex.
	bond0: link status definitely down for interface eth1, disabling it
	bond0: making interface eth0 the new active one.

	# ifconfig
	bond0     Link encap:Ethernet  HWaddr 08:00:27:43:66:17  
		      inet addr:10.0.2.12  Bcast:10.255.255.255  Mask:255.0.0.0
		      inet6 addr: fe80::a00:27ff:fe43:6617/64 Scope:Link
		      UP BROADCAST RUNNING MASTER MULTICAST  MTU:1500  Metric:1

	eth0      Link encap:Ethernet  HWaddr 08:00:27:43:66:17  
		      UP BROADCAST RUNNING SLAVE MULTICAST  MTU:1500  Metric:1
 
During the above test, the client network connection from host 10.0.0.1 (ssh) was maintained without any noticeable interruption. As it can be seen from the syslog and ifconfig command output, the bond0 interface was automatically assigned either the MAC address of eth0 or eth1 and the fail-over worked as advertised.
