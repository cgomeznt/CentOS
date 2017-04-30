Instalar python 3.4.5 sin afectar las otras instalaciones
==========================================================

Descargar python
https://www.python.org/downloads/release/python-345/

Instalar pyton
https://tecadmin.net/install-python-3-4-on-centos-rhel-fedora/

Install Required Packages

Use the following command to install prerequisites for Python before installing it.::

	# yum install gcc

Now extract the downloaded package.::

	# tar xzf Python-3.4.5.tgz

Compile Python Source

Use below set of commands to compile python source code on your system using altinstall.::

	# cd Python-3.4.5
	# ./configure
	# make altinstall

make altinstall is used to prevent replacing the default python binary file /usr/bin/python.

Now remove downloaded source archive file from your system.::

	# rm Python-3.4.5.tgz

Check Python Version

Check the latest version installed of python using below command.::

	# python3.4 -V

	Python 3.4.5


Crear los link symbolics para python 3.4.::

	# ls -l /usr/local/bin/python*
	# rm -f /usr/local/bin/python
	# ln -s /usr/local/bin/python3.4 /usr/local/bin/python
	# ls -l /usr/local/bin/python*
	# python --version


CUIDADO, si yum falla es porque le movistes de /usr/bin/python
http://www.linuxquestions.org/questions/fedora-35/python3-2-vs-yum-4175419559/
