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

  # vgcreate vg_postgres /dev/sdb1
   Volume group "vg_postgres" successfully created

  # lvcreate -L +6G -n lv_postgres vg_postgres
   Logical volume "lv_postgres" created

Crear un sistema de archivos XFS en la partición lvm
----------------------------------------------------

Creamos un sistema de archivos XFS para el nuevo LV “/dev/vg_postgres/lv_postgres”::

  # mkfs.xfs /dev/vg_postgres/lv_postgres
  
Crear un directorio para el punto de montura
--------------------------------------------

Cree un directorio denominado postgres en /::

  # mkdir /postgres
  
  
Montar el nuevo LV en el punto de montura
-------------------------------------------

Montar el sistemas de archivos XFS, en el punto de montura que le corresponde::

  # mount /dev/mapper/vg_postgres-lv_postgres /postgres

Editar el fstab
------------------

Para el montaje permanente, utilice el archivo /etc/fstab, pero antes desmontamos el /postgres::

  # unmount /postgres
  
Procedemos a editar el /etc/fstab::

  # vi /etc/fstab

  # /etc/fstab: static file system information.
  #
  # Use 'blkid' to print the universally unique identifier for a
  # device; this may be used with UUID= as a more robust way to name devices
  # that works even if disks are added and removed. See fstab(5).
  #
  # <file system> <mount point>   <type>  <options>       <dump>  <pass>
  /dev/mapper/vg_root-lv_root /               xfs     defaults        0       0
  /dev/mapper/vg_home-lv_home /home           xfs     defaults        0       0
  /dev/mapper/vg_tmp-lv_tmp /tmp            xfs     defaults        0       0
  /dev/mapper/vg_usr-lv_usr /usr            xfs     defaults        0       0
  /dev/mapper/vg_var-lv_var /var            xfs     defaults        0       0
  /dev/mapper/vg_postgres-lv_postgres /postgres            xfs     defaults        0       0
  /dev/mapper/vg_swap-lv_swap none            swap    sw              0       0
  /dev/sr0        /media/cdrom0   udf,iso9660 user,noauto     0       0

Hacemos que el sistema recargue el fstab::

  # mount -a
  
  
Consultamos que se vea el nuevo FS::

  # fdisk -l



 

