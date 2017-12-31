Lo primero que tenemos que hacer es elegir la ruta del repositorio y crear la estructura de carpetas, 
vamos a crear la misma estructura que en los repositorios oficiales, en este caso para la versión 5.6 de CentOS i386::

	# mkdir -p /repo_local/centos/5.6/os/i386/CentOS/

Luego descargaos los rpm de la pagina o los copiamos directamente si los tenemos.::

	# wget --mirror --recursive --no-paren http://rpms.adiscon.com/v7-stable/epel-6/x86_64/

Instalar una utilidad de yum llamada createrepo::

	# yum install createrepo

Una vez instalado podemos crear el repositorio con el siguiente comando::

	# createrepo repo_local

	Saving Primary metadata
	Saving file lists metadata
	Saving other metadata

Nota: Este comando hay que ejecutarlo cada vez que añadimos, eliminamos o hacemos algún cambio en los rpm del repositorio.

Una vez creado podemos sincronizar nuestro repositorio con uno de los mirror oficiales de CentOS por rsync 
o añadir nuestros propios RPM. 

Antes de empezar a trabajar con él tenemos que activar el repositorio, para ello creamos un nuevo fichero con la configuración 
del mismo en /etc/yum.repos.d/repo_local.repo (el fichero debe tener la extensión .repo)::

	[repo_local]
	name=Repositorio_local_CentOS
	baseurl=file:///repo_local/
	enabled=1
	gpgcheck=0

La estructura es sencilla, indicamos el nombre del repositorio, su ruta (podría ser SMB, NFS, HTTP…), 
si está activado y si usa algún tipo de llave gpg (en este caso no). Ahora ya podemos hacer consultas contra este repositorio, 
instalar rpm’s, etc. Vamos a consultar. 
En el comando que veis deshabilito el repositorio base para evitar problemas de prioridades, etc::

	# yum --disablerepo=\* --enablerepo=rsyslog search rsyslog

	Loaded plugins: fastestmirror
	Loading mirror speeds from cached hostfile
	===================================================== N/S Matched: rsyslog =====================================================
	rsyslog-debuginfo.x86_64 : Debug information for package rsyslog
	rsyslog-gnutls.x86_64 : TLS protocol support for rsyslog
	rsyslog-gssapi.x86_64 : GSSAPI authentication and encryption support for rsyslog
	rsyslog-libdbi.x86_64 : libdbi database support for rsyslog
	rsyslog-mysql.x86_64 : MySQL support for rsyslog
	rsyslog-pgsql.x86_64 : PostgresSQL support for rsyslog
	rsyslog-relp.x86_64 : RELP protocol support for rsyslog
	rsyslog-snmp.x86_64 : SNMP protocol support for rsyslog
	rsyslog.x86_64 : a rocket-fast system for log processing
	rsyslog-elasticsearch.x86_64 : Provides the omelasticsearch module
	rsyslog-mmanon.x86_64 : mmanon support
	rsyslog-mmfields.x86_64 : mmfields support
	rsyslog-mmjsonparse.x86_64 : mmjsonparse support
	rsyslog-mmnormalize.x86_64 : mmnormalize support
	rsyslog-mmutf8fix.x86_64 : mmutf8fix support
	rsyslog-mongodb.x86_64 : MongoDB output support
	rsyslog-ommail.x86_64 : Mail support
	rsyslog-pmaixforwardedfrom.x86_64 : pmaixforwardedfrom support
	rsyslog-udpspoof.x86_64 : Provides the omudpspoof module

  Name and summary matches only, use "search all" for everything.


Si el repositorio lo quisierais además de para vuestros RPM personalizados para los oficiales de CentOS, 
deberíais sincronizarlo periódicamente con un mirror oficial y ejecutar después el createrepo. Podéis hacerlo en un cron, 
siendo el comando algo así::

	# rsync -avz centos.mirror.xtratelecom.es::CentOS/5.6 /repo_local/centos/ && createrepo repo_local

Nota: no todos los repositorios aceptan rsync, en la lista de mirrors de CentOS veréis los que sí que lo permiten. 
El que uso en el ejemplo sí.
