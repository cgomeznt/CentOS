Crear un repo local
=======================

Cear una estructura de directorio.::

	# mkdir -p /repo

Instalar createrepo.::

	# yum install createrepo

Construir un conjunto de paquetes nuevos desde unsrc, o alternativamente obtener paquetes desde unafuentes confiables.::

	$ rpmbuild --rebuild /path/to/srpm/foo-1.2.3.4-1.el4.src.rpm
	/home/builduser/rpmbuild/RPMS/foo-1.2.3.4-1.el4.i386.rpm
	/home/builduser/rpmbuild/RPMS/foo-devel-1.2.3.4-1.el4.i386.rpm
	/home/builduser/rpmbuild/RPMS/foo-docs-1.2.3.4-1.el4.i386.rpm

	# mv /home/builduser/rpmbuild/RPMS/foo* /repo
	# chown -R root.root /repo

Tambien lo podemos descargar de un repositorio en la nube.::

	# cd /repo
	# wget --mirror --recursive --no-parent http://rpms.adiscon.com/v7-stable/epel-6/

Ahora le damos la estructura al repositorio para que sea entendible por yum.::

	# createrepo /share/CentOS/4/local/i386


Crear /etc/yum.repos.d/Centos.local.repo (1 enabled y 0 disabled).::

	# vi /etc/yum.repos.d/Centos.local.repo

	[rsyslog]
	name=CentOS- rsyslog - local
	# baseurl=https://direccion-ip # crea un virtual host
	baseurl=file:///repo
	enabled=0
	gpgcheck=0

Para repositorios vía HTTP o FTP la línea de baseurl debe ser modificada según corresponda.

Instalar paquetes en el servidor para probar el repositorio.::

	# yum --disablerepo=\* --enablerepo=rsyslog info rsyslog
	# yum --disablerepo=\* --enablerepo=rsyslog search rsyslog
	# yum --disablerepo=\* --enablerepo=rsyslog update rsyslog

