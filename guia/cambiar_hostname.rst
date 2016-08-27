CAMBIAR EL HOSTNAME
=====================

Para cambiar el hostname necesitamos editar los siguientes tres archivos y colocaremos el nuevo hostname

/etc/hosts::

	# Do not remove the following line, or various programs
	# that require network functionality will fail.
	127.0.0.1 tmcent01.training5.tm localhost.localdomain localhost

/etc/sysconfig/network::

	NETWORKING=yes
	NETWORKING_IPV6=yes
	HOSTNAME=tmcent01.training5.tm
	GATEWAY=192.168.75.2

/proc/sys/kernel/hostname::

	srv-01.local.host

Si el sistema no nos deja modificar este último archivo porque se encuentra en uso podemos ejecutar el siguiente comando que es equivalente::

	# echo srv-01.local.host > /proc/sys/kernel/hostname
