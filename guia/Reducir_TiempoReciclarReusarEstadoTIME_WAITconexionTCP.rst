Reducir el Tiempo, Reciclar y Reusar el Estado TIME_WAIT en conexión TCP
===========================================================================
A continuación esquema(Según Protocolo de Control de Transmisión RFC: 793) secuencia normal de cierre de una conexión TCP:

https://www.rfc-es.org/rfc/rfc0793-es.txt

Esto es un extracto del RFC: 793 para enterder las conexiones:

Una conexión progresa de acuerdo con una serie de estados durante su tiempo de vida. Los estados son: 
'LISTEN' (en escucha), 
'SYN-SENT' (SYN enviado), 
'SYN-RECEIVED' (SYN recibido), 
'ESTABLISHED' (establecida), 
'FIN-WAIT-1' ("en espera de fin-1"), 
'FIN-WAIT-2' ("en espera de fin-2"), 
'CLOSE-WAIT' (en espera de cierre), 
'CLOSING' (cerrándose), 
'LAST-ACK' (último acuse de recibo), 
'TIME-WAIT' (en espera), 
y el estado ficticio 'CLOSED' (cerrada).  
'CLOSED' es un estado ficticio porque representa el estado en el que no existe TCB, y
por lo tanto, no hay conexión.  De forma breve, los significados de los estados son (N.T.:de aquí en adelante no se entrecomillarán los
estados y llaamdas salvo cuando aparezcan en frases en mayúsculas)::

    LISTEN - representa la espera de una solicitud de conexión
    proveniente de cualquier TCP y puerto remotos.

    SYN-SENT - representa la espera de una solicitud de conexión
    concordante tras haber enviado previamente una solicitud de
    conexión.

    SYN-RECEIVED - representa la espera del acuse de recibo confirmando
    la solicitud de conexión tras haber recibido tanto como envíado una
    solicitud de conexión.

    ESTABLISHED - representa una conexión abierta, los datos recibidos
    pueden ser entregados al usuario. El estado normal para la fase de
    transferencia de una conexión.

    FIN-WAIT-1 - representa la espera de una solicitud de finalización
    de la conexión proveniente del TCP remoto, o del acuse de recibo de
    la solicitud de finalización previamente envíada.

    FIN-WAIT-2 - representa la espera de una solicitud de finalización
    del TCP remoto.

    CLOSE-WAIT - representa la espera de una solicitud de finalización
    de la conexión proveniente del usuario local.

    CLOSING - representa la espera del paquete, proveniente del TCP
    remoto, con el acuse de recibo de la solicitud de finalización.

    LAST-ACK - representa la espera del acuse de recibo de la solicitud
    de finalización de la conexión previamente envíada al TCP remoto (lo
    que incluye el haber envíado el acuse de recibo de la solicitud remota de finalización de la conexión).

    TIME-WAIT - representa la espera durante suficiente tiempo para
    asegurar que el TCP remoto recibió el acuse de recibo de su
    solicitud de finalización de la conexión.

    CLOSED - representa un estado sin conexión en absoluto
	
	
	
Este diagrama únicamente es un resumen y no debe ser tomado como la especificación total


                              +---------+ ---------\      OPEN activo
env=enviar                    |  CLOSED |            \    -----------
rec=recibir                   +---------+<---------\   \   crear TCB
                                |     ^              \   \  env SYN
                   OPEN pasivo  |     |   CLOSE        \   \
                   ------------ |     | ----------       \   \
                    crear TCB   |     | borrar TCB         \   \
                                V     |                      \   \
                              +---------+            CLOSE    |    \
                              |  LISTEN |          ---------- |     |
                              +---------+          borrar TCB |     |
                   rec SYN      |     |     SEND              |     |
                  -----------   |     |    -------            |     V
 +---------+      env SYN,ACK  /       \   env SYN          +---------+
 |         |<-----------------           ------------------>|         |
 |   SYN   |                    rcv SYN                     |   SYN   |
 |   RCVD  |<-----------------------------------------------|   SENT  |
 |         |                    snd ACK                     |         |
 |         |------------------           -------------------|         |
 +---------+   rec ACK de SYN  \       /  rec SYN,ACK       +---------+
   |           --------------   |     |   -----------
   |                  x         |     |     env ACK
   |                            V     V
   |  CLOSE                   +---------+
   | -------                  |  ESTAB  |
   | env FIN                  +---------+
   |                   CLOSE    |     |    rec FIN
   V                  -------   |     |    -------
 +---------+          env FIN  /       \   env ACK          +---------+
 |  FIN    |<-----------------           ------------------>|  CLOSE  |
 | WAIT-1  |------------------                              |   WAIT  |
 +---------+          rec FIN  \                            +---------+
   | rec ACK de FIN   -------   |                            CLOSE  |
   | --------------   env ACK   |                           ------- |
   V        x                   V                           env FIN V
 +---------+                  +---------+                   +---------+
 |FINWAIT-2|                  | CLOSING |                   | LAST-ACK|
 +---------+                  +---------+                   +---------+
   |                rec ACK de FIN |                 rec ACK de FIN |
   |  rec FIN       -------------- |      Plazo=2MSL -------------- |
   |  -------              x       V      ----------        x       V
    \ env ACK                 +---------+ borrar TCB        +---------+
     ------------------------>|TIME WAIT|------------------>| CLOSED  |
                              +---------+                   +---------+
							  
							  
secuencia normal de cierre de una conexión TCP:

       TCP A                                                TCP B

  1.  ESTABLISHED                                          ESTABLISHED

  2.  (Close)
      FIN-WAIT-1  --> <SEQ=100><ACK=300><CTL=FIN,ACK>  --> CLOSE-WAIT

  3.  FIN-WAIT-2  <-- <SEQ=300><ACK=101><CTL=ACK>      <-- CLOSE-WAIT

  4.                                                       (Close)
      TIME-WAIT   <--  <SEQ=300><ACK=101><CTL=FIN,ACK> <-- LAST-ASK

  5.  TIME-WAIT   --> <SEQ=101><ACK=301><CTL=ACK>      --> CLOSED

  6.  (2 MSL)
      CLOSED
	  


1. Verificar las conexiones TIME_WAIT
+++++++++++++++++++++++++++++++++++++++++

::

	# netstat -nat | awk '{print $6}' | sort | uniq -c
		  6 CLOSE_WAIT
		  1 established)
		 18 ESTABLISHED
		  1 Foreign
		 38 LISTEN
		 10 TIME_WAIT

2. Disminuir los tiempos de duración y activar el reciclado y reuso de las conexiones con estado TIME_WAIT, editar systcl
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

::

	# vi /etc/systcl.conf
	
Efectuar los siguientes cambios::

	 # Disminuir tiempo TIME_WAIT segundos 
	 net.ipv4.tcp_fin_timeout = 30

	 # Activar Reciclar y reusar TIME_WAIT
	 net.ipv4.tcp_tw_recycle = 1
	 net.ipv4.tcp_tw_reuse = 1
	 # Disminuir el KeepAlive
	 net.ipv4.tcp_keepalive_time = 120
	 net.ipv4.tcp_keepalive_intvl = 30
	 net.ipv4.tcp_keepalive_probes = 3
		
3. Aplicar los cambios:
++++++++++++++++++++++++

::

	# systcl -p /etc/sysctl.conf
	
4. Verificar los cambios:
++++++++++++++++++++++++++

::

	# cat /proc/sys/net/ipv4/tcp_fin_timeout
	 30

	# cat /proc/sys/net/ipv4/tcp_tw_recycle
	 1

	# cat /proc/sys/net/ipv4/tcp_tw_reuse
	 1
		 
