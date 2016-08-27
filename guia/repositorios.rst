Repositorios EPEL CentOS
==========================

¿Qué es EPEL?
EPEL (paquetes adicionales para Enterprise Linux) es un proyecto de la comunidad, libre y de código abierto basado en Fedora que proporciona 100% complementos de alta calidad en paquetes de software para la distribución de Linux incluyendo Red Hat Enterprise Linux (Red Hat Enterprise Linux), CentOS y Scientific Linux. Proyecto Epel no es una parte de RHEL / CentOS pero está diseñado para las principales distribuciones de Linux, proporcionando una gran cantidad de paquetes de código abierto como la creación de redes, administrador de sistemas, programación, seguimiento y así sucesivamente. La mayoría de los paquetes de EPEL son mantenidos por Fedora.

En CentOS 7:
------------

Repositorio CentOS Extras


El repositorio de CentOS Extras incluye un paquete EPEL para instalar, y está activado por defecto. Para instalar el paquete EPEL, ejecute el siguiente comando::

	sudo yum install epel-release

En caso de no tener instalado o no querer instalar el repositorio "Extras", el proceso es el siguiente:

CentOS y Red Hat Enterprise Linux 7.x
--------------------------------------

:: 
	wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
	sudo rpm -Uvh epel-release-7*.rpm

Para RHEL y Centos 6
------------------------

En primer lugar, es necesario descargar el archivo con Wget y luego instalarlo usando RPM en su sistema. Para habilitar el repositorio EPEL. Utilice a continuación los enlaces basados en sus versiones del SO Linux. (Asegúrese de que usted sea el usuario root).

RHEL / CentOS 6 32-64 Bit
-----------------------------

## RHEL/CentOS 6 32-Bit ##::

	# wget http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
	# rpm -ivh epel-release-6-8.noarch.rpm

## RHEL/CentOS 6 64-Bit ##::

	# wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
	# rpm -ivh epel-release-6-8.noarch.rpm

RHEL / CentOS 5 32-64 Bit
--------------------------

## RHEL/CentOS 5 32-Bit ##::

	# wget http://download.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
	# rpm -ivh epel-release-5-4.noarch.rpm

## RHEL/CentOS 5 64-Bit ##::

	# wget http://download.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
	# rpm -ivh epel-release-5-4.noarch.rpm

RHEL / CentOS 4 32-64 Bit
----------------------------

## RHEL/CentOS 4 32-Bit ##::

	# wget http://download.fedoraproject.org/pub/epel/4/i386/epel-release-4-10.noarch.rpm
	# rpm -ivh epel-release-4-10.noarch.rpm

## RHEL/CentOS 4 64-Bit ##::

	# wget http://download.fedoraproject.org/pub/epel/4/x86_64/epel-release-4-10.noarch.rpm
	# rpm -ivh epel-release-4-10.noarch.rpm


¿Cómo puedo verificar EPEL Repo?
Tiene que ejecutar el siguiente comando para verificar que el repositorio EPEL está habilitado. Una vez que ejecute el comando verá el repositorio EPEL.::

	# yum repolist
	Ejemplo de salida

	Loaded plugins: downloadonly, fastestmirror, priorities
	Loading mirror speeds from cached hostfile
	 * base: centos.aol.in
	 * epel: ftp.cuhk.edu.hk
	 * extras: centos.aol.in
	 * rpmforge: be.mirror.eurid.eu
	 * updates: centos.aol.in
	Reducing CentOS-5 Testing to included packages only
	Finished
	1469 packages excluded due to repository priority protections
	repo id                           repo name                                                      status
	base                              CentOS-5 - Base                                               2,718+7
	epel Extra Packages for Enterprise Linux 5 - i386 4,320+1,408
	extras                            CentOS-5 - Extras                                              229+53
	rpmforge                          Red Hat Enterprise 5 - RPMforge.net - dag                      11,251
	repolist: 19,075


¿Cómo se usa el repositorio EPEL?
Es necesario utilizar el comando YUM para la búsqueda y la instalación de paquetes. Por ejemplo buscamos el paquete Zabbix usando el repo EPEL, vamos a ver que está disponible o no bajo EPEL.::

	# yum --enablerepo=epel info zabbix
	Ejemplo de salida

	Available Packages
	Name       : zabbix
	Arch       : i386
	Version    : 1.4.7
	Release    : 1.el5
	Size       : 1.7 M
	Repo : epel
	Summary    : Open-source monitoring solution for your IT infrastructure
	URL        : http://www.zabbix.com/
	License    : GPL
	Description: ZABBIX is software that monitors numerous parameters of a network.e una red. 
	Vamos a instalar el paquete Zabbix usando repo EPEL con la opción: –enablerepo=epel

::

# yum --enablerepo=epel install zabbix

Nota: El archivo de configuración EPEL se encuentra en  /etc/yum.repos.d/epel.repo. De esta manera usted puede instalar tantos paquetes de código abierto como quiera.
