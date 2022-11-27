Cómo hacer crecer/extender el sistema de archivos XFS en CentOS/RHEL usando el comando "xfs_growfs"
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Use el comando xfs_growfs para aumentar el tamaño de un sistema de archivos XFS. El sistema de archivos XFS debe estar montado y debe haber espacio disponible en el dispositivo subyacente. La utilidad xfs_growfs se usa con mayor frecuencia con volúmenes lógicos. La sintaxis del comando xfs_growfs es la siguiente::

	# xfs_growfs [options] mount-point


Las siguientes opciones están disponibles para el comando xfs_growfs::


* -d: expande la sección de datos del sistema de archivos al tamaño máximo del dispositivo subyacente.
* -D [tamaño]: especifique el tamaño para expandir la sección de datos del sistema de archivos. El argumento [tamaño] se expresa en el número de bloques del sistema de archivos.
* -L [tamaño]: especifique el nuevo tamaño del área de registro. Esto no expande el tamaño, pero especifica el nuevo tamaño del área de registro. Por lo tanto, esta opción se puede usar para reducir el tamaño del área de registro. No puede reducir el tamaño de la sección de datos del sistema de archivos.
* -m [maxpct]: especifique el nuevo valor para el porcentaje máximo de espacio en el sistema de archivos que se puede asignar como inodes. Con el comando mkfs.xfs, esta opción se especifica con la opción –i maxpct = [valor].


**Extensión del sistema de archivos XFS**

1. Verifique el tamaño actual del sistema de archivos XFS::

	# xfs_growfs -n /var
	meta-data=/dev/mapper/vg_var-lv_var isize=512    agcount=4, agsize=32000 blks
		 =                       sectsz=512   attr=2, projid32bit=1
		 =                       crc=1        finobt=0 spinodes=0
	data     =                       bsize=4096   blocks=128000, imaxpct=25
		 =                       sunit=0      swidth=0 blks
	naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
	log      =internal               bsize=4096   blocks=855, version=2
		 =                       sectsz=512   sunit=0 blks, lazy-count=1
	realtime =none                   extsz=4096   blocks=0, rtextents=0



La opción -n en realidad no extiende el sistema de archivos XFS, sino que solo imprime los detalles del sistema de archivos actual. También verifique la salida del comando “df -h” para ver el tamaño actual del punto de montaje.::

	# df -h /var
	/dev/mapper/vg_var-lv_var  497M   26M  472M   6% /var


2. Extienda el dispositivo subyacente (lvextend, crecer LUN, expandir partición).
Antes de que crezcamos el sistema de archivos XFS, necesitamos extender el volumen LVM subyacente. Si es posible, puede extender un volumen físico existente en el LVM VG. A los efectos de esta publicación, utilizaremos un nuevo PV para expandir un LV.

2.1. Identifique el nuevo disco y cree un Volumen físico.::

	# pvcreate /dev/sdc


2.2. Amplíe el grupo de volúmenes vg_test usando el nuevo PV.::

	# vgextend vg_var /dev/sdc


2.3. Verifique el nuevo tamaño del grupo de volúmenes.::

	# vgdisplay vg_var
	  --- Volume group ---
	  VG Name               vg_var
	  System ID             
	  Format                lvm2
	  Metadata Areas        2
	  Metadata Sequence No  3
	  VG Access             read/write
	  VG Status             resizable
	  MAX LV                0
	  Cur LV                1
	  Open LV               1
	  Max PV                0
	  Cur PV                2
	  Act PV                2
	  VG Size               39.99 GiB
	  PE Size               4.00 MiB
	  Total PE              10238
	  Alloc PE / Size       125 / 500.00 MiB
	  Free  PE / Size       10113 / 39.50 GiB
	  VG UUID               wrd9eB-aZo3-HCmD-Rlgr-NcGP-vS2Z-cm2CeQ


2.4. Extienda el volumen lógico al tamaño deseado usando el comando "lvresize".::

	# lvresize -L +35g /dev/vg_var/lv_var
	  Size of logical volume vg_var/lv_var changed from 500.00 MiB (125 extents) to 35.49 GiB (9085 extents).
	  Logical volume vg_var/lv_var successfully resized.

3. Growing the XFS file system::

	# xfs_growfs /var
	meta-data=/dev/mapper/vg_var-lv_var isize=512    agcount=4, agsize=32000 blks
		 =                       sectsz=512   attr=2, projid32bit=1
		 =                       crc=1        finobt=0 spinodes=0
	data     =                       bsize=4096   blocks=128000, imaxpct=25
		 =                       sunit=0      swidth=0 blks
	naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
	log      =internal               bsize=4096   blocks=855, version=2
		 =                       sectsz=512   sunit=0 blks, lazy-count=1
	realtime =none                   extsz=4096   blocks=0, rtextents=0
	data blocks changed from 128000 to 9303040

Observer que la ultima linea le esta informando que existe una modificación::

	data blocks changed from 128000 to 9303040

4. Verificar
4.1. Puede ver los detalles del volumen XFS utilizando el comando "xfs_info" como se muestra a continuación. Tenga en cuenta los bloques para el volumen de datos.::

	# xfs_info /var
	meta-data=/dev/mapper/vg_var-lv_var isize=512    agcount=291, agsize=32000 blks
		 =                       sectsz=512   attr=2, projid32bit=1
		 =                       crc=1        finobt=0 spinodes=0
	data     =                       bsize=4096   blocks=9303040, imaxpct=25
		 =                       sunit=0      swidth=0 blks
	naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
	log      =internal               bsize=4096   blocks=855, version=2
		 =                       sectsz=512   sunit=0 blks, lazy-count=1
	realtime =none                   extsz=4096   blocks=0, rtextents=0

Vea como en esta linea el blocks cambio::

	data     =                       bsize=4096   blocks=9303040, imaxpct=25

Verifique el nuevo tamaño del sistema de archivos XFS en la salida del comando “df -h”.::

	# df -hP /var
	Filesystem                   Size  Used Avail Use% Mounted on
	/dev/mapper/vg_var-lv_var   36G   35M   36G   1% /var

Como puede ver en la salida anterior, el tamaño del punto de montaje de datos se ha incrementado de 500 MB a ~ 36 GB.
