lvm
=====

Crear Physical Volumes
++++++++++++++++++++++

The *pvcreate* es el comando utilizado para inicializar el PV para el LVM. Antes de crear el PV debemos estar seguros que los discos a utilizar estan visibles. Podemos utilizar *fdisk* o *lvmdiskscan*.::

	# lvmdiskscan 
	  /dev/ram0             [      16,00 MiB] 
	  /dev/root             [      10,31 GiB] 
	  /dev/ram1             [      16,00 MiB] 
	  /dev/sda1             [     500,00 MiB] 
	  /dev/VolGroup/lv_swap [       1,20 GiB] 
	  /dev/ram2             [      16,00 MiB] 
	  /dev/sda2             [      11,51 GiB] LVM physical volume
	  /dev/VolGroup1/lv_opt [      19,98 GiB] 
	  /dev/ram3             [      16,00 MiB] 
	  /dev/ram4             [      16,00 MiB] 
	  /dev/ram5             [      16,00 MiB] 
	  /dev/ram6             [      16,00 MiB] 
	  /dev/ram7             [      16,00 MiB] 
	  /dev/ram8             [      16,00 MiB] 
	  /dev/ram9             [      16,00 MiB] 
	  /dev/ram10            [      16,00 MiB] 
	  /dev/ram11            [      16,00 MiB] 
	  /dev/ram12            [      16,00 MiB] 
	  /dev/ram13            [      16,00 MiB] 
	  /dev/ram14            [      16,00 MiB] 
	  /dev/ram15            [      16,00 MiB] 
	  /dev/sdb1             [      10,00 GiB]
	  /dev/sdb2             [       9,99 GiB] 
	  3 disks
	  17 partitions
	  0 LVM physical volume whole disks
	  3 LVM physical volumes

Aunque mas facil es con fdisk.::

	# fdisk -l

	Disco /dev/sda: 12.9 GB, 12884901888 bytes
	255 heads, 63 sectors/track, 1566 cylinders
	Units = cilindros of 16065 * 512 = 8225280 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes
	Disk identifier: 0x0005212c

	Disposit. Inicio    Comienzo      Fin      Bloques  Id  Sistema
	/dev/sda1   *           1          64      512000   83  Linux
	La partición 1 no termina en un límite de cilindro.
	/dev/sda2              64        1567    12069888   8e  Linux LVM

	Disco /dev/sdb: 21.5 GB, 21474836480 bytes
	255 heads, 63 sectors/track, 2610 cylinders
	Units = cilindros of 16065 * 512 = 8225280 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes
	Disk identifier: 0xe64f3c55

	Disposit. Inicio    Comienzo      Fin      Bloques  Id  Sistema
	/dev/sdb1               1        1306    10490413+  83  Linux
	/dev/sdb2            1307        2610    10474380   83  Linux

	Disco /dev/mapper/VolGroup-lv_root: 11.1 GB, 11068768256 bytes
	255 heads, 63 sectors/track, 1345 cylinders
	Units = cilindros of 16065 * 512 = 8225280 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes
	Disk identifier: 0x00000000


	Disco /dev/mapper/VolGroup-lv_swap: 1287 MB, 1287651328 bytes
	255 heads, 63 sectors/track, 156 cylinders
	Units = cilindros of 16065 * 512 = 8225280 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes
	Disk identifier: 0x00000000

Inicializamos los dispositivos de bloques.::

	# pvcreate /dev/sdb1 /dev/sdb2
	  Physical volume "/dev/sdb1" successfully created
	  Physical volume "/dev/sdb2" successfully created

Listamos los physical volumes, podemos utilizar *pvdisplay*, *pvs* o *pvscan*.::

	# pvdisplay 
	  --- Physical volume ---
	  PV Name               /dev/sda2
	  VG Name               VolGroup
	  PV Size               11,51 GiB / not usable 3,00 MiB
	  Allocatable           yes (but full)
	  PE Size               4,00 MiB
	  Total PE              2946
	  Free PE               0
	  Allocated PE          2946
	  PV UUID               NI3zVs-YehI-vUS5-LS9Z-cQDk-pIki-KntSmJ
	   
	  "/dev/sdb1" is a new physical volume of "10,00 GiB"
	  --- NEW Physical volume ---
	  PV Name               /dev/sdb1
	  VG Name               
	  PV Size               10,00 GiB
	  Allocatable           NO
	  PE Size               0   
	  Total PE              0
	  Free PE               0
	  Allocated PE          0
	  PV UUID               UB0NsR-i312-gduP-YaqZ-sqp1-5wkE-ESvQqx
	   
	  "/dev/sdb2" is a new physical volume of "9,99 GiB"
	  --- NEW Physical volume ---
	  PV Name               /dev/sdb2
	  VG Name               
	  PV Size               9,99 GiB
	  Allocatable           NO
	  PE Size               0   
	  Total PE              0
	  Free PE               0
	  Allocated PE          0
	  PV UUID               m5ToQH-6T3p-dVOR-2FBP-DMWQ-DBAM-VDtwus

::

	# pvscan 
	  PV /dev/sda2   VG VolGroup   lvm2 [11,51 GiB / 0    free]
	  PV /dev/sdb1                 lvm2 [10,00 GiB]
	  PV /dev/sdb2                 lvm2 [9,99 GiB]

::

	# pvs
	  PV         VG       Fmt  Attr PSize  PFree 
	  /dev/sda2  VolGroup lvm2 a--  11,51g     0 
	  /dev/sdb1           lvm2 ---  10,00g 10,00g
	  /dev/sdb2           lvm2 ---   9,99g  9,99g

Creamos el Volume Group
++++++++++++++++++++++++

Utilizamos *vgcreate* para crear los volume group.::

	# vgcreate VolGroup1 /dev/sdb1
	  Volume group "VolGroup1" successfully created

Listamos la informacion de los VG.::

	# vgs
	  VG        #PV #LV #SN Attr   VSize  VFree 
	  VolGroup    1   2   0 wz--n- 11,51g     0 
	  VolGroup1   1   0   0 wz--n- 10,00g 10,00g

::

	# vgdisplay VolGroup1
	  --- Volume group ---
	  VG Name               VolGroup1
	  System ID             
	  Format                lvm2
	  Metadata Areas        1
	  Metadata Sequence No  1
	  VG Access             read/write
	  VG Status             resizable
	  MAX LV                0
	  Cur LV                0
	  Open LV               0
	  Max PV                0
	  Cur PV                1
	  Act PV                1
	  VG Size               10,00 GiB
	  PE Size               4,00 MiB
	  Total PE              2560
	  Alloc PE / Size       0 / 0   
	  Free  PE / Size       2560 / 10,00 GiB
	  VG UUID               OqNBdn-0wMQ-Bvnp-sALg-2AfE-bJW1-4UjxGt

Activar o Desactivar los VGs, con *vgchange* activamos o desactivamos los volume group.
Para desactivar.::

	# vgchange -a n VolGroup1
	  0 logical volume(s) in volume group "VolGroup1" now active

Para activarlo.::

	# vgchange -a y VolGroup1
	  1 logical volume(s) in volume group "VolGroup1" now active

Creando Logical Volume
++++++++++++++++++++++
::

	# lvcreate -L10G -n lv_opt VolGroup1
	  Logical volume "lv_opt" created.

Listar informacion de los LV.::

	# lvs
	  LV      VG        Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
	  lv_root VolGroup  -wi-ao---- 10,31g                                                    
	  lv_swap VolGroup  -wi-ao----  1,20g                                                    
	  lv_opt  VolGroup1 -wi-a----- 10,00g   

::

	# lvdisplay /dev/VolGroup1/lv_opt 
	  --- Logical volume ---
	  LV Path                /dev/VolGroup1/lv_opt
	  LV Name                lv_opt
	  VG Name                VolGroup1
	  LV UUID                zxAaKb-oojj-E0Xk-09o6-GEu7-m0et-SKqGmU
	  LV Write Access        read/write
	  LV Creation host, time srvoracle, 2017-12-23 21:17:47 -0400
	  LV Status              available
	  # open                 1
	  LV Size                10,00 GiB
	  Current LE             5115
	  Segments               2
	  Allocation             inherit
	  Read ahead sectors     auto
	  - currently set to     256
	  Block device           252:2

::

	# lvscan 
	  ACTIVE            '/dev/VolGroup1/lv_opt' [10,00 GiB] inherit
	  ACTIVE            '/dev/VolGroup/lv_root' [10,31 GiB] inherit
	  ACTIVE            '/dev/VolGroup/lv_swap' [1,20 GiB] inherit

Creando el File System
++++++++++++++++++++++++
::

	# mkfs.ext4 /dev/VolGroup1/lv_opt
	mke2fs 1.43-WIP (20-Jun-2013)
	Etiqueta del sistema de ficheros=
	OS type: Linux
	Tamaño del bloque=4096 (bitácora=2)
	Tamaño del fragmento=4096 (bitácora=2)
	Stride=0 blocks, Stripe width=0 blocks
	655360 inodes, 2621440 blocks
	131072 blocks (5.00%) reserved for the super user
	Primer bloque de datos=0
	Número máximo de bloques del sistema de ficheros=2684354560
	80 bloque de grupos
	32768 bloques por grupo, 32768 fragmentos por grupo
	8192 nodos-i por grupo
	Respaldo del superbloque guardado en los bloques: 
		32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

	Allocating group tables: hecho                           
	Escribiendo las tablas de nodos-i: hecho                           
	Creating journal (32768 blocks): hecho
	Escribiendo superbloques y la información contable del sistema de ficheros: hecho

::

	# mount /dev/VolGroup1/lv_opt /opt

::

	# df -h
	Filesystem            Size  Used Avail Use% Mounted on
	/dev/mapper/VolGroup-lv_root
		               11G  2,9G  6,7G  30% /
	tmpfs                 1,8G     0  1,8G   0% /dev/shm
	/dev/sda1             477M   78M  371M  18% /boot
	/dev/mapper/VolGroup1-lv_opt
		              9,8G  677M  8,6G   8% /opt


Redimensionar un volumen logico
+++++++++++++++++++++++++++++++


Crear physical volume.::

	# pvcreate /dev/sdb2
	  Physical volume "/dev/sdb2" successfully created

Extender el volume group.::
 
	# vgextend VolGroup1 /dev/sdb2
	  Volume group "VolGroup1" successfully extended

Extender el Logical group.::

	# lvextend -L +9,98G /dev/VolGroup1/lv_opt 
	  Rounding size to boundary between physical extents: 9,98 GiB
	  Size of logical volume VolGroup1/lv_opt changed from 10,00 GiB (2560 extents) to 19,98 GiB (5115 extents).
	  Logical volume lv_opt successfully resized

::

	# vgs
	  VG        #PV #LV #SN Attr   VSize  VFree
	  VolGroup    1   2   0 wz--n- 11,51g    0 
	  VolGroup1   2   1   0 wz--n- 19,98g 4,00m

Redimensionar el sistema de archivos, porque lo extendimos en LVM pero no el sistema de archivo y lo podemos ver esto con *df*.::

	# df -h
	Filesystem            Size  Used Avail Use% Mounted on
	/dev/mapper/VolGroup-lv_root
		               11G  2,9G  6,7G  30% /
	tmpfs                 1,8G     0  1,8G   0% /dev/shm
	/dev/sda1             477M   78M  371M  18% /boot
	/dev/mapper/VolGroup1-lv_opt
		              9,8G  3,7G  5,6G  40% /opt
	[root@srvoracle eclipse]# umount /opt/
	umount: /opt: device is busy.
		(In some cases useful info about processes that use
		 the device is found by lsof(8) or fuser(1))

Desmontamos el volumen.::

# umount /opt/

Verificamos la salud del file system.::

	# e2fsck -f /dev/VolGroup1/lv_opt
	e2fsck 1.43-WIP (20-Jun-2013)
	Paso 1: Verificando nodos-i, bloques y tamaños
	Paso 2: Verificando la estructura de directorios
	Paso 3: Revisando la conectividad de directorios
	Paso 4: Revisando las cuentas de referencia
	Paso 5: Revisando el resumen de información de grupos

Redimencionamos el file system.::

	# resize2fs /dev/VolGroup1/lv_opt 
	resize2fs 1.43-WIP (20-Jun-2013)
	Resizing the filesystem on /dev/VolGroup1/lv_opt to 5237760 (4k) blocks.
	The filesystem on /dev/VolGroup1/lv_opt is now 5237760 blocks long.

Montamos el volumen y certificamos que ya tenemos todo el espacio.::

	# mount /dev/VolGroup1/lv_opt /opt

::

	# fdisk -l

	Disco /dev/sda: 12.9 GB, 12884901888 bytes
	255 heads, 63 sectors/track, 1566 cylinders
	Units = cilindros of 16065 * 512 = 8225280 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes
	Disk identifier: 0x0005212c

	Disposit. Inicio    Comienzo      Fin      Bloques  Id  Sistema
	/dev/sda1   *           1          64      512000   83  Linux
	La partición 1 no termina en un límite de cilindro.
	/dev/sda2              64        1567    12069888   8e  Linux LVM

	Disco /dev/sdb: 21.5 GB, 21474836480 bytes
	255 heads, 63 sectors/track, 2610 cylinders
	Units = cilindros of 16065 * 512 = 8225280 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes
	Disk identifier: 0xe64f3c55

	Disposit. Inicio    Comienzo      Fin      Bloques  Id  Sistema
	/dev/sdb1               1        1306    10490413+  83  Linux
	/dev/sdb2            1307        2610    10474380   83  Linux

	Disco /dev/mapper/VolGroup-lv_root: 11.1 GB, 11068768256 bytes
	255 heads, 63 sectors/track, 1345 cylinders
	Units = cilindros of 16065 * 512 = 8225280 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes
	Disk identifier: 0x00000000


	Disco /dev/mapper/VolGroup-lv_swap: 1287 MB, 1287651328 bytes
	255 heads, 63 sectors/track, 156 cylinders
	Units = cilindros of 16065 * 512 = 8225280 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes
	Disk identifier: 0x00000000


	Disco /dev/mapper/VolGroup1-lv_opt: 21.5 GB, 21453864960 bytes
	255 heads, 63 sectors/track, 2608 cylinders
	Units = cilindros of 16065 * 512 = 8225280 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes
	Disk identifier: 0x00000000


Por recordar, podemos crear striped volume y mirrored volume, aahh y tambien es bueno recordar que se puede achicar un volumen lógico y cómo eliminar volúmenes lógicos, grupos de volúmenes y volúmenes físicos.








