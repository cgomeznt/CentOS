Configurar time Zone en CentOS 6 y 7
=====================================


Una zona horaria no es más que una región del mundo que observa un tiempo estándar uniforme para propósitos constitucionales, comerciales y culturales. En una zona horaria breve se refiere a la hora local de un país. Puede cambiar fácilmente la zona horaria en CentOS Linux utilizando los siguientes métodos.

Pero existe el El tiempo universal coordinado o UTC (de una transigencia entre la versión en inglés Coordinated Universal Time y la versión en francés Temps universel coordonné) es el principal estándar de tiempo por el cual el mundo regula los relojes y el tiempo.

Los sistemas operativos en realidad utilizan el UTC como tiempo principal y luego es que utiliza el Timezone para sumar o restar así sea el caso.

Ejemplo:

Consultamos el UTC del equipo.::
	# date -u
	mar sep 24 19:55:26 UTC 2019

Verificamos el Timezone que tiene configurado el SO.::

	# timedatectl | grep Time
	       Time zone: America/Manaus (-04, -0400)

Ahora consultamos la fecha del equipo y podemos ver como le resta al UTC menos 4 horas.::
	
	# date 
	mar sep 24 15:55:37 -04 2019

Ahora que ya tenemos claro esto continuamos.


CentOS timezone archivos de configuración y directorios
++++++++++++++++++++++++++++++++++++++++++++++++++++++++

**/usr/share/zoneinfo/** – En este directorio se encuentran los archivos por nombre de cada Timezone.

**/etc/localtime** – Es un enlace simbólico del archivo ubicado en el directorio /usr/share/zoneinfo/


Como ver cual es el Timezone actual del CentOS Linux?
++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Tipiamos el siguiente comando.::

	# date -u
	mar sep 24 20:04:17 UTC 2019
	# date
	mar sep 24 16:04:19 -04 2019
	# ls -l /etc/localtime 
	lrwxrwxrwx 1 root root 34 sep 24 15:28 /etc/localtime -> /usr/share/zoneinfo/America/Manaus

En el ejemplo anterior el Timezone es Manaus es decir resta -4 al UTC.

Otra opción en CentOS 7 es.::

	# timedatectl 
	      Local time: mar 2019-09-24 16:07:34 -04
	  Universal time: mar 2019-09-24 20:07:34 UTC
		RTC time: lun 2018-09-24 23:13:37
	       Time zone: America/Manaus (-04, -0400)
	     NTP enabled: n/a
	NTP synchronized: no
	 RTC in local TZ: no
	      DST active: n/a

	# timedatectl | grep Time
	       Time zone: America/Manaus (-04, -0400)

	# date
	mar sep 24 16:07:38 -04 2019


Para configurar el Timezone
+++++++++++++++++++++++++++++++

La forma manual de realizar esta configuración es muy simple y funciona en CentOS 6 y CentOS 7.::

	# ls -l  /etc/localtime 
	lrwxrwxrwx. 1 root root 38 may 28  2018 /etc/localtime -> ../usr/share/zoneinfo/America/New_York


	# ls /usr/share/zoneinfo/America/Manaus

	# rm /etc/localtime

	# ln -s /usr/share/zoneinfo/America/Manaus /etc/localtime

	# ls -l  /etc/localtime 
	lrwxrwxrwx 1 root root 34 sep 24 15:28 /etc/localtime -> /usr/share/zoneinfo/America/Manaus



Otra forma de hacerlo en CentOS 7 es.::

	# timedatectl

	# timedatectl list-timezones

	# timedatectl list-timezones | grep Manaus
	America/Manaus

	# timedatectl set-timezone America/Manaus


	Ahora verificamos.::

	# timedatectl

	# date









