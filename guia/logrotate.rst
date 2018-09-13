Configurar logrotate
======================

Administrar log files de forma correcta es una tarea esencial para un Linux sysadmin

Rotar los archivos de log cuando tengan o superen un tamaño especifico.
Continuar con la escritura del lot en un nuevo archivo despues de haber rotado el log.
Comprimir el log rotado.
Especificar opciones de comprimido para rotar el log.
Colocarle una fecha al log rotado.
Ejecutar script inmediatamente de haber sido rotado el log.
Remover viejos log rotados .
 

1. Logrotate Archivo de configuracion

/usr/sbin/logrotate – logrotate binario.

/etc/cron.daily/logrotate – Script que ejecuta el binario por medio del cron.::

	$ cat /etc/cron.daily/logrotate
	#!/bin/sh

	/usr/sbin/logrotate /etc/logrotate.conf
	EXITVALUE=$?
	if [ $EXITVALUE != 0 ]; then
		/usr/bin/logger -t logrotate "ALERT exited abnormally with [$EXITVALUE]"
	fi
	exit 0

/etc/logrotate.conf – Archivo de configuracion para todos los logs, por lo normal todas las aplicaciones ya crean su archivo de configuracion dentro de /etc/logrotate.d/ .::

	$ cat /etc/logrotate.conf
	weekly
	rotate 4
	create
	include /etc/logrotate.d
	/var/log/wtmp {
		monthly
		minsize 1M
		create 0664 root utmp
		rotate 1
	}

/etc/logrotate.d – Por lo normal cuando un paquete se instala en el sistema, este coloca su configuracion aqui en este directorio. por ejemplo, yum, syslog, mysqld, httpd, zabbix-server, etc.::

	$ cat /etc/logrotate.d/yum
	/var/log/yum.log {
		missingok
		notifempty
		size 30k
		yearly
		create 0600 root root
	}

2. Logrotate size option: Rota el log cuando el archivo tenga ess tamaño o lo haya superado.::

	$ cat /etc/logrotate.d/zabbix-server 
	/var/log/zabbix/zabbix_server.log {
		missingok
		#monthly
		size 3k
		rotate 4
		notifempty
		compress
		create 0664 zabbix zabbix
	}

Esta configuracion logrotate tiene estas opciones:

size 3k – logrotate solo corre si tiene 3k o mas.
create – Rota el log y crea uno nuevo con las especificaciones de permisos, usuario y grupo.
rotate – Limita el numreo de rotacion de loglimits the number of log file rotation.
compress – comprime el log rotado.::

	$ ls -l /tmp/output.log
	-rw-r--r-- 1 zabbix zabbix 25868 2010-06-09 21:19 /tmp/output.log

	$ logrotate -s /var/log/logstatus logrotate.conf

	$ ls -l /tmp/output*
	-rw-r--r--  1 zabbix zabbix 25868 2010-06-09 21:20 output.log.1
	-rwx------ 1 zabbix zabbix        0 2010-06-09 21:20 output.log
	
Eventually this will keep following setup of rotated log files.::

	output.log.4.
	output.log.3
	output.log.2
	output.log.1
	output.log

Please remember that after the log rotation, the log file corresponds to the service would still point to rotated file (output.log.1) and keeps on writing in it. You can use the above method, if you want to rotate the apache access_log or error_log every 5 MB.

Ideally, you should modify the /etc/logrotate.conf to specify the logrotate information for a specific log file.

Also, if you are having huge log files, you can use: 10 Awesome Examples for Viewing Huge Log Files in Unix

3. Logrotate copytruncate option: Continue to write the log information in the newly created file after rotating the old log file.::

	$ cat logrotate.conf
	/tmp/output.log {
		     size 1k
		     copytruncate
		     rotate 4
	}

copytruncate instruct logrotate to creates the copy of the original file (i.e rotate the original log file) and truncates the original file to zero byte size. This helps the respective service that belongs to that log file can write to the proper file.

While manipulating log files, you might find the sed substitute, sed delete tips helpful.

4. Logrotate compress option: Compress the rotated log files
If you use the compress option as shown below, the rotated files will be compressed with gzip utility.::

	$ cat logrotate.conf
	/tmp/output.log {
		    size 1k
		    copytruncate
		    create 700 bala bala
		    rotate 4
		    compress
	}

Output of compressed log file::

	$ ls /tmp/output*
	output.log.1.gz output.log

5. Logrotate dateext option: Rotate the old log file with date in the log filename.::

	$ cat logrotate.conf
	/tmp/output.log {
		    size 1k
		    copytruncate
		    create 700 bala bala
		    dateext
		    rotate 4
		    compress
	}

After the above configuration, you’ll notice the date in the rotated log file as shown below.::

	$ ls -lrt /tmp/output*
	-rw-r--r--  1 bala bala 8980 2010-06-09 22:10 output.log-20100609.gz
	-rwxrwxrwx 1 bala bala     0 2010-06-09 22:11 output.log

This would work only once in a day. Because when it tries to rotate next time on the same day, earlier rotated file will be having the same filename. So, the logrotate wont be successful after the first run on the same day.

Typically you might use tail -f to view the output of the log file in realtime. You can even combine multiple tail -f output and display it on single terminal.

6. Logrotate monthly, daily, weekly option: Rotate the log file weekly/daily/monthly
For doing the rotation monthly once,::

$ cat logrotate.conf
/tmp/output.log {
        monthly
        copytruncate
        rotate 4
        compress
}
Add the weekly keyword as shown below for weekly log rotation.

	$ cat logrotate.conf
	/tmp/output.log {
		    weekly
		    copytruncate
		    rotate 4
		    compress
	}

Add the daily keyword as shown below for every day log rotation. You can also rotate logs hourly.::

	$ cat logrotate.conf
	/tmp/output.log {
		    daily
		    copytruncate
		    rotate 4
		    compress
	}

7. Logrotate postrotate endscript option: Run custom shell scripts immediately after log rotation
Logrotate allows you to run your own custom shell scripts after it completes the log file rotation. The following configuration indicates that it will execute myscript.sh after the logrotation.::

	$ cat logrotate.conf
	/tmp/output.log {
		    size 1k
		    copytruncate
		    rotate 4
		    compress
		    postrotate
		           /home/bala/myscript.sh
		    endscript
	}

8. Logrotate maxage option: Remove older rotated log files
Logrotate automatically removes the rotated files after a specific number of days.  The following example indicates that the rotated log files would be removed after 100 days.::

	$ cat logrotate.conf
	/tmp/output.log {
		    size 1k
		    copytruncate
		    rotate 4
		    compress
		    maxage 100
	}

9. Logrotate missingok option: Dont return error if the log file is missing
You can ignore the error message when the actual file is not available by using this option as shown below.::

	$ cat logrotate.conf
	/tmp/output.log {
		    size 1k
		    copytruncate
		    rotate 4
		    compress
		    missingok
	}

10. Logrotate compresscmd and compressext option: Sspecify compression command for the log file rotation.::

	$ cat logrotate.conf
	/tmp/output.log {
		    size 1k
		    copytruncate
		    create
		    compress
		    compresscmd /bin/bzip2
		    compressext .bz2
		    rotate 4
	}

Following compression options are specified above:

compress – Indicates that compression should be done.
compresscmd – Specify what type of compression command should be used. For example: /bin/bzip2
compressext – Specify the extension on the rotated log file. Without this option, the rotated file would have the default extension as .gz. So, if you use bzip2 compressioncmd, specify the extension as .bz2 as shown in the above example.


Personalizar el logrotate
++++++++++++++++++++++++++++

Si se quiere que el logrotate este ejecutando cada hora se debe crear un script.
Debe crear primero el archivo en /etc/logrotate.d/
luego en /etc/cron.hourly/nombredelscript.crontab
recuerda otorgar permisos de ejecucion.::

Ejemplo del archivo en /etc/logrotate.d.::

	/var/log/ldap.log {
		#su wso2 wso2
		copytruncate
		missingok
		size 2M
		rotate 4
		notifempty
		compress
		postrotate
		        /bin/systemctl restart slapd.service > /dev/null 2>/dev/null || true
		        /bin/systemctl restart rsyslog.service > /dev/null 2>/dev/null || true
		endscript
	}



Ejemplo del archivo en el /etc/cron.hourly.::

	vi /etc/cron.hourly/openldap.cron

	# esto seria un ejemplo del contenido, el archivo /etc/logrotate.d/openldaplog ya debe existir y estar operativo con le logrotate
	#!/bin/sh
	/usr/sbin/logrotate /etc/logrotate.d/openldaplog
	EXITVALUE=0
	if [  != 0 ]; then
		 /usr/bin/logger -t logrotate "ALERT exited abnormally with [$EXITVALUE]"
	fi
	exit 0
