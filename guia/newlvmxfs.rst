Crear y ampliar el sistema de archivos XFS basado en LVM
========================================================

Crea una partición usando fdisk
--------------------------------

Creado una partición de 10 GB en /dev/sdb y configurar::

  # fdisk /dev/sdb
  
NOTA: Lo anterior si solo si, queremos particionar el Disco, sino simplemente lo utilizamos, es decir, No particionamos y en los siguientes comandos utilizamos /dev/sdb

Crear componentes LVM
---------------------

Con los comandos pvcreate, vgcreate y lvcreate::

  # pvcreate /dev/sdb1
   Physical volume "/dev/sdb1" successfully created

  # vgcreate vg_xfs /dev/sdb1
   Volume group "vg_xfs" successfully created

  # lvcreate -L +6G -n xfs_db vg_xfs
   Logical volume "xfs_db" created

Crear un sistema de archivos XFS en la partición lvm
----------------------------------------------------

Creamos un sistema de archivos XFS para el nuevo LV “/dev/vg_postgres/lv_postgres”::

  # mkfs.xfs /dev/vg_postgres/lv_postgres
  
Monte el sistema de archivos xfs 
---------------------------------

Montar el sistemas de archivos XFS, en el punto de montura que le corresponde

Cree un directorio denominado postgres en / y móntelo con el comando de montaje::

  # mkdir /postgres
  
Para el montaje permanente, utilice el archivo /etc/fstab.


 

