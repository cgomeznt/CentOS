IPTables
===========

En este artículo es de CentOS, trataremos brevemente algunas de las cosas que podemos realizar con iptables. Además, brindaremos una buena idea de los aspectos básicos de iptables que nos permitirán construir conjuntos de reglas más complejas.

Contents
---------

- Introducción
- Comenzando
- Escribiendo un conjunto de reglas simples
- Interfaces
- Direcciones IP
- Puertos y Protocolos
- Poniendo todo junto
- Enlaces

1. Introducción
----------------

CentOS tiene una estructura interna de cortafuegos extremadamente poderosa, comúnmente nos referimos a ella como iptables pero más correctamente es iptables/netfilter. Iptables es el módulo para el espacio de usuario, la parte con la cual usted, el usuario, interactúa en la línea de comandos para entrar las reglas del cortafuegos en las tablas predefinidas. Netfilter es el módulo del núcleo, construido dentro del núcleo. Actualmente este es el que se encarga del filtrado.

Existen varias presentaciones GUI para iptables que le permiten a los usuarios adicionar o definir reglas basadas en un punto y con el clic del usuarios en la interface, pero estos a menudo carecen de la flexibilidad de usar la línea de comando y limitan la comprensión de los usuarios de lo que está pasando realmente. Vamos a aprender la interface de línea de comando de iptables.

Antes de que podamos enfrentarnos a iptables necesitamos tener al menos una comprensión básica de su forma de trabajo. Iptables usa el concepto de direcciones ip, protocolos (tcp, udp, icmp) y puertos. No necesitamos ser expertos en estos temas para comenzar (ya que podemos buscar cualquier información que necesitemos), pero ayuda tener una comprensión general.

Iptables ubica las reglas dentro de cadenas predefinidas (INPUT, OUTPUT y FORWARD) que son comprobadas contra cualquier tráfico de red (paquetes IP) relevantes para esas cadenas y una decisión es tomada sobre que hacer con cada paquete basado en el significado de esas reglas, por ejemplo aceptar o rechazar el paquete. Estas acciones son referidas como objetivos (targets), de las cuales las dos más usadas son DROP para rechazar un paquete o ACCEPT para permitir el paquete.

Cadenas
--------

Existen tres cadenas predefinidas en la tabla de filtrado para las cuales podemos adicionar reglas para procesar los paquetes IP que pasan a través de las cadenas. Estas cadenas son:

INPUT - Todos los paquetes dirigidos a la computadora anfitrión.
OUTPUT - Todos los paquetes originados en la computadora anfitrión.
FORWARD - Todos los paquetes que no son originados o dirigidos a la computadora anfitrión, pero pasan a través (enrutados) de la computadora anfitrión. Esta cadena es usada si usted está usando su computadora como un enrutador.
La mayor parte del tiempo, estaremos tratando con la cadena INPUT para filtrar los paquetes que entran a nuestra computadora - y así mantener fuera a los muchachos malos.

Las reglas son adicionadas a la lista de cada cadena. Un paquete es comprobado contra cada regla en turno, comenzando por arriba. Si el paquete coincide con esa regla, entonces una acción es realizada, ej. aceptar (ACCEPT), o rechazar (DROP) el paquete. Una vez que la regla ha coincidido y una acción realizada, entonces el paquete es procesado de acuerdo al resultado de la regla y no es procesada por reglas posteriores en la cadena. Si un paquete pasa todas las reglas en la cadena hasta abajo y llega al final sin haber coincidido con regla alguna, entonces es utilizada la acción por defecto para esa cadena. Esto se refiere a la política por defecto y puede estar fijada en aceptar o en rechazar el paquete.

El concepto de la política predeterminada dentro de las cadenas permite dos posibilidades fundamentales que debemos considerar primero, antes de decidir cómo vamos a organizar el cortafuegos.

1. Podemos fijar una política predeterminada para rechazar todos los paquetes y entonces adicionar reglas para permitir (ACCEPT) paquetes específicos que pueden venir de direcciones IP confiables o para algunos puertos en los cuales tenemos servicios corriendo, tales como bittorrent, servidor FTP, servidor Web, servidor de ficheros Samba, etc.

o alternativamente,

2. Podemos fijar una política para permitir todos los paquetes y entonces adicionar reglas que rechacen paquetes específicos que pueden vinir de direcciones o rangos IP engorrosas o para algunos puertos en los cuales tenemos servicios privados o ningún servicio corriendo.

Generalmente, la opción 1 de arriba es usada para la cadena INPUT donde controlamos a que queremos permitir acceso en nuestra computadora y la opción 2 sería usada en la cadena OUTPUT donde generalmente confiamos en el tráfico que está saliendo de (originado en) nuestra computadora.

2. Comenzando
-------------

El trabajo con iptables desde la línea de comando requiere los privilegios de root, así que usted necesitará convertirse en root para la mayoría de las cosas que estaremos haciendo.

attachment:ArtWork/WikiDesign/icon-admonition-info.png
NOTA: Estaremos apagando y reseteando las reglas de su cortafuegos. Así que debería estar al tanto de esto si ha confiado la primera línea de defensa a su cortafuegos Linux.
Iptables debe estar instalado por defecto en todas las instalaciones de CentOS 3.x, 4.x y 5.x. Puede comprobar si iptables está instalado en sus sistema con:
::

	$ rpm -q iptables
	iptables-1.3.5-1.2.1

Para ver si iptables está corriendo, podemos comprobar que los módulos de iptables están cargados y usar la opción -L para inspeccionar las reglas que que están cargadas actualmente:
::

	# lsmod | grep ip_tables
	ip_tables              29288  1 iptable_filter
	x_tables               29192  6 ip6t_REJECT,ip6_tables,ipt_REJECT,xt_state,xt_tcpudp,ip_tables

	# iptables -L
	Chain INPUT (policy ACCEPT)
	target     prot opt source               destination
	RH-Firewall-1-INPUT  all  --  anywhere             anywhere
	Chain FORWARD (policy ACCEPT)
	target     prot opt source               destination
	RH-Firewall-1-INPUT  all  --  anywhere             anywhere
	Chain OUTPUT (policy ACCEPT)
	target     prot opt source               destination
	Chain RH-Firewall-1-INPUT (2 references)
	target     prot opt source               destination
	ACCEPT     all  --  anywhere             anywhere
	ACCEPT     icmp --  anywhere             anywhere            icmp any
	ACCEPT     esp  --  anywhere             anywhere
	ACCEPT     ah   --  anywhere             anywhere
	ACCEPT     udp  --  anywhere             224.0.0.251         udp dpt:mdns
	ACCEPT     udp  --  anywhere             anywhere            udp dpt:ipp
	ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:ipp
	ACCEPT     all  --  anywhere             anywhere            state RELATED,ESTABLISHED
	ACCEPT     tcp  --  anywhere             anywhere            state NEW tcp dpt:ssh
	REJECT     all  --  anywhere             anywhere            reject-with icmp-host-prohibited

Arriba vemos el conjunto de reglas predeterminadas además del acceso al servicio SSH.

Si iptables no está corriendo puede habilitarlo ejecutando:
::

	# system-config-securitylevel

3. Escribiendo un conjunto de reglas simples
--------------------------------------------

attachment:ArtWork/WikiDesign/icon-admonition-info.png
NOTA: En este punto vamos a limpiar el conjunto de reglas predeterminadas.
Usaremos un ejemplo que nos permitirá examinar los comandos de iptables. En este primer ejemplo crearemos un conjunto de reglas muy simples para configurar un cortafuegos del tipo Stateful Packet Inspection (SPI) que permitirá todas las conexiones salientes pero bloqueará todas las conexiones entrantes indeseada.
::

	# iptables -F
	# iptables -P INPUT DROP
	# iptables -P FORWARD DROP
	# iptables -P OUTPUT ACCEPT
	# iptables -A INPUT -i lo -j ACCEPT
	# iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
	# iptables -L -v

lo cual debe darle la siguiente salida::


	Chain INPUT (policy DROP 0 packets, 0 bytes)
	 pkts bytes target     prot opt in     out     source               destination
		0     0 ACCEPT     all  --  lo     any     anywhere             anywhere
		0     0 ACCEPT     all  --  any    any     anywhere             anywhere            state RELATED,ESTABLISHED
	Chain FORWARD (policy DROP 0 packets, 0 bytes)
	 pkts bytes target     prot opt in     out     source               destination
	Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
	 pkts bytes target     prot opt in     out     source               destination

Ahora vamos a ver cada uno de los siete comandos de arriba y comprender exactamente lo que acabamos de hacer:

iptables -F : Lo primero que hemos hecho es usar la opción -F para eliminar las reglas una por una, de forma tal que comencemos con un estado limpio en el cual comenzar a adicionar reglas nuevas.
iptables -P INPUT DROP : La opción -P fija la política por defecto en la cadena especificada. Así que aquí estamos fijando a DROP como la política por defecto en la cadena INPUT. Esto quiere decir que si un paquete entrante no coincide una de las reglas siguientes será descartado.
iptables -P FORWARD DROP : De la misma forma, aquí estamos fijando a DROP la política por defecto para la cadena FORWARD porque no estamos usando nuestra computadora como un enrutador así que no deberían estar pasando paquetes a través de nuestra computadora.
iptables -P OUTPUT ACCEPT : y finalmente fijamos a ACCEPT la política por defecto para la cadena OUTPUT porque queremos permitir todo el tráfico saliente (porque confiamos en nuestros usuarios).
iptables -A INPUT -i lo -j ACCEPT : Ahora es el momento de comenzar a adicionar algunas reglas. Usamos la opción -A para anexar (o adicionar) una regla a la cadena específica, en este caso la cadena INPUT. Luego usamos la opción -i (interface) para especificar los paquetes que coinciden o están destinados a la interface lo (localhost, 127.0.0.1) y finalmente -j (jump) para saltar al objetivo de acción para el paquete que coincide con la regla, en este caso ACCEPT. Así, esta regla permitirá que todos los paquetes entrantes con destino a la interface localhost sean aceptados. Esto generalmente requiere que las aplicaciones de software sean capaces de comunicarse con el adaptador localhost.
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT : Esta es la regla que hace la mayor parte del trabajo y nuevamente estamos adicionando (-A) a la cadena INPUT. Aquí estamos usando la opción -m para cargar un módulo (state). El módulo estado está disponible para examinar el estado de un paquete y determinar si este es nuevo (NEW), establecido (ESTABLISHED) o relacionado (RELATED). NEW se refiere a los paquetes entrantes que son conexiones entrantes nuevas que fueron iniciadas por el sistema anfitrión. ESTABLISHED y RELATED se refieren a los paquetes entrantes que son parte de una conexión ya establecida o relacionada a la conexión ya establecida.
iptables -L -v : Listar (-L) las reglas que acabamos de adicionar para comprobar que han sido cargadas correctamente.
Finalmente, lo último que necesitamos hacer es salvar las reglas para que la próxima vez que reiniciemos la computadora nuestras reglas sean recargadas automáticamente::


	# /sbin/service iptables save

Esto ejecuta el script init de iptables el cual corre /sbin/iptables-save y escribe la configuración actual de iptables a /etc/sysconfig/iptables. Con el reinicio, el script init de iptables vuelve a aplicar las reglas salvadas en /etc/sysconfig/iptables usando el comando /sbin/iptables-restore.

Obviamente escribir estos comandos directamente en el shell puede ser tedioso, así que la forma más fácil de trabajar con iptables es crear un script simple para hacer todo esto por usted. Los comandos de arriba pueden ser entrados en su editor de texto favorito y ser salvado como myfirewall, por ejemplo::


	#!/bin/bash
	#
	# iptables example configuration script
	#
	# Flush all current rules from iptables
	#
	 iptables -F
	#
	# Set default policies for INPUT, FORWARD and OUTPUT chains
	#
	 iptables -P INPUT DROP
	 iptables -P FORWARD DROP
	 iptables -P OUTPUT ACCEPT
	#
	# Set access for localhost
	#
	 iptables -A INPUT -i lo -j ACCEPT
	#
	# Accept packets belonging to established and related connections
	#
	 iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
	#
	# Save settings
	#
	 /sbin/service iptables save
	#
	# List rules
	#
	 iptables -L -v


NOTA: Podemos comentar nuestro script para recordar lo que estamos haciendo.
Ahora haga el script ejecutable::

	# chmod +x myfirewall

Ahora podemos editar simplemente nuestro script y correrlo desde el shell con el comando siguiente::

	# ./myfirewall

4. Interfaces
-------------

En nuestro ejemplo anterior vimos como podemos aceptar todos los paquetes entrantes a una interface particular, en este caso la interface localhost::

	iptables -A INPUT -i lo -j ACCEPT

Supongamos que tenemos dos interfaces separadas, eth0 la cual es nuestra conexión LAN interna y ppp0 dialup modem (o talvés eth1 para una nic) la cual es nuestra conexión externa a internet. Podemos necesitar todos los paquetes entrantes a nuestra LAN interna pero continuar filtrando paquetes entrantes hacia nuestra conexión externa de internet. Podríamos hacer lo siguiente::

	iptables -A INPUT -i lo -j ACCEPT
	iptables -A INPUT -i eth0 -j ACCEPT

Pero tenga mucho cuidado - si vamos a permitir todos esos paquetes para nuestra interface externa de internet (por ejemplo ppp0 dialup modem)::

	iptables -A INPUT -i ppp0 -j ACCEPT

efectivamente, con esto tendríamos deshabilitado nuestro cortafuegos!

5. Direcciones IP
-----------------

Abrir una interface completa a los paquetes entrantes puede no ser lo suficientemente restrictivo y usted puede necesitar más control como para decir que permitir y que rechazar. Vamos a suponer que tenemos una pequeña red de computadoras que usan la sub red privada 192.168.0.x. Podemos abrir nuestro cortafuegos para los paquetes entrantes desde una sola dirección IP en la cual confiamos (por ejemplo 192.168.0.4):


# Accept packets from trusted IP addresses
::
	iptables -A INPUT -s 192.168.0.4 -j ACCEPT # change the IP address as appropriate

Desglosando este comando, primero anexamos (-A) una regla para la cadena INPUT que acepta (ACCEPT) todos los paquetes para la dirección IP de origen (-s) 192.168.0.4. (Observe como podemos utilizar el símbolo # para adicionar comentarios en línea que permitan documentar nuestro script. Cualquier cosa que ponga después del # será ignorado y tratado como un comentario).

Obviamente si queremos permitir paquetes entrantes desde un rango de direcciones podemos aplicar una regla para cada dirección IP que confiamos y eso debería funcionar bien. Pero si tenemos muchas de ellas, esto puede hacerse más fácil si adicionamos el rango de direcciones IP en una sola línea. Para hacer esto podemos utilizar una mascara de red o la notación estándar de slash para especificar un rango de direcciones IP. Por ejemplo, si queremos abrir nuestro cortafuegos para todos los paquetes entrantes desde el rango 192.168.0.x (donde x = de 1 a 254), podemos utilizar cualquiera de los métodos siguientes:


# Accept packets from trusted IP addresses
::
	iptables -A INPUT -s 192.168.0.0/24 -j ACCEPT  # using standard slash notation
	iptables -A INPUT -s 192.168.0.0/255.255.255.0 -j ACCEPT # using a subnet mask

Finalmente, de la misma forma que filtramos contra una sola dirección IP, podemos también hacer coincidir la dirección MAC de un dispositivo dado. Para hacer esto, necesitamos cargar el módulo (mac) que permite filtrar contra direcciones mac. Anteriormente vimos un ejemplo del uso de módulos para extender la funcionalidad de iptables cuando usamos el módulo estado para hacer coincidir los paquetes ESTABLISHED y RELATED. Aquí usamos el módulo mac para comprobar la dirección mac de un origen de paquetes, además de su dirección IP:


# Accept packets from trusted IP addresses
::
	iptables -A INPUT -s 192.168.0.4 -m mac --mac-source 00:50:8D:FD:E6:32 -j ACCEPT

Primero usamos -m mac para cargar el módulo mac y luego usamos --mac-source para especificar la dirección mac de la dirección IP origen (192.168.0.4). Usted necesitará encontrar la dirección mac de cada dispositivo ethernet contra el cual esté filtrando. Ejecutando ifconfig (o iwconfig para los dispositivos inalámbricos) como root le mostrará la dirección mac.

Esto puede ser útil en la prevención de la falsificación de direcciones IP originales, pues permitirá a cualquier paquete que sea genuinamente originado de la dirección 192.168.0.4 (con la dirección mac 00:50:8D:FD:E6:32) pero rechazará cualquier paquete que sea falsificado para mostrarse como originario de esa dirección IP.

attachment:ArtWork/WikiDesign/icon-admonition-info.png
NOTA: del autor - Estoy inseguro con respecto al funcionamiento del filtrado por dirección mac a través de internet pero de seguro trabaja bien en una LAN (Rectifíquenme).
6. Puertos y Protocolos

Arriba hemos visto como adicionar reglas a nuestro cortafuegos para filtrar contra paquetes que coinciden con una interface particular o una dirección IP de origen. Esto permite un acceso completo a través de nuestro cortafuegos para algunos orígenes confiables (PCs anfitriones). Ahora veremos como podemos filtrar contra protocolos y puertos para refinar cuales paquetes permitimos entrar y cuales rechazamos.

Antes que comencemos, necesitamos saber que protocolo y número de puerto un servicio determinado usa. Por ejemplo, veamos el caso de bittorrent. Bittorrent usa el protocolo tcp en el puerto 6881, así que necesitamos permitir todos los paquetes tcp que tengan como destino el puerto 6881 (en nuestra computadora):


# Accept tcp packets on destination port 6881 (bittorrent)
::
	iptables -A INPUT -p tcp --dport 6881 -j ACCEPT

Aquí anexamos (-A) una regla para la cadena INPUT para los paquetes que coinciden con el protocolo tcp (-p tcp) y que están entrando a nuestra computadora al puerto 6881 (--dport 6881).


NOTA: Para poder usar las coincidencias de puerto de origen o puerto de destino (--sport o --dport), usted debe especificar primero el protocolo (tcp, udp, icmp, all).
Podemos extender lo de arriba para incluir un rango de puertos, por ejemplo, para permitir todos los paquetes tcp en el rango de 6881 a 6890:


# Accept tcp packets on destination ports 6881-6890
::
	iptables -A INPUT -p tcp --dport 6881:6890 -j ACCEPT

7. Poniendo todo junto
-----------------------

Ahora que hemos visto las bases, podemos comenzar a combinar estas reglas.

Un servicio popular de UNIX/Linux es el servicio de shell seguro (SSH) que permite hacer login remoto. Por defecto SSH usa el puerto 22 y el protocolo tcp. Así, si queremos permitir logins remotos, necesitamos permitir las conexiones tcp entrantes al puerto 22:


# Accept tcp packets on destination port 22 (SSH)
::
	iptables -A INPUT -p tcp --dport 22 -j ACCEPT

Esto abrirá el puerto 22 (SSH) para todas las conexiones tcp lo cual es una potencial brecha de seguridad pues los hackers pueden intentar el cracking por fuerza bruta en cuentas con contraseñas débiles. Sin embargo, si sabemos la dirección IP de la computadora remota en la cual confiamos, esa que será usada para hacer login SSH, podemos limitar el acceso solo esta dirección IP de origen. Por ejemplo, si deseamos abrir solamente el acceso SSH a nuestra LAN privada (192.168.0.x), podemos limitar el acceso solo a este rango de direcciones IP:


# Accept tcp packets on destination port 22 (SSH) from private LAN
::
	iptables -A INPUT -p tcp -s 192.168.0.0/24 --dport 22 -j ACCEPT

El uso del filtrado por IP de origen nos permite abrir seguramente el acceso SSH en el puerto 22 solo a las direcciones IP en las que confiamos. Por ejemplo, podemos usar este método para permitir logins remotos entre las computadoras del trabajo y las del hogar. Para el resto de las direcciones IP, el puerto (y servicio) aparecería cerrado como si el servicio estuviese deshabilitado. De esta forma los hackers que usan los métodos de escaneo de puertos posiblemente nos pasen por un lado.


