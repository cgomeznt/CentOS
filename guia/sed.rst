Algunos buenos del comando sed
============================

Este es el archivo de demo::

	$ cat file1.txt 
	# Documentacion
	#de algo
	Veamos este ejemplo
	veamos este otro ejemplo
	10081551
	10081599
	10082234
	10082259
	20081134
	20081159
	30082232
	10087721

Eliminar los dos primeros caracteres de todas las lineas::

	$ sed 's/^..//' file1.txt
	Documentacion
	de algo
	amos este ejemplo
	amos este otro ejemplo
	081551
	081599
	082234
	082259
	081134
	081159
	082232
	087721


Eliminar los dos ultimos caracteres de todas las lineas::

	$ sed 's/..$//' file1.txt 
	# Documentaci
	# de al
	Veamos este ejemp
	veamos este otro ejemp
	100815
	100815
	100822
	100822
	200811
	200811
	300822
	100877


Eliminar el primer caracter qeu coincida con la cadena::

	$ sed 's/^V//' file1.txt 
	# Documentacion
	# de algo
	eamos este ejemplo
	veamos este otro ejemplo
	10081551
	10081599
	10082234
	10082259
	20081134
	20081159
	30082232
	10087721

Eliminar el ultimo caracter qeu coincida con la cadena::

	$ sed 's/n$//' file1.txt 
	# Documentacio
	# de algo
	Veamos este ejemplo
	veamos este otro ejemplo
	10081551
	10081599
	10082234
	10082259
	20081134
	20081159
	30082232
	10087721

Eliminar el primer y ultimo caractere de todas las lineas::

	$ sed 's/^.\(.*\).$/\1/' file1.txt 
	 Documentacio
	de alg
	eamos este ejempl
	eamos este otro ejempl
	008155
	008159
	008223
	008225
	008113
	008115
	008223
	008772

Eliminar multiples caracteres::

	$ sed 's/[osj]//g' file1.txt 
	# Dcumentacin
	#de alg
	Veam ete eempl
	veam ete tr eempl
	10081551
	10081599
	10082234
	10082259
	20081134
	20081159
	30082232
	10087721

Elimina todo luego de la coincidencia de un caracter::

	$ sed 's/j.*//g' file1.txt 
	# Documentacion
	#de algo
	Veamos este e
	veamos este otro e
	10081551
	10081599
	10082234
	10082259
	20081134
	20081159
	30082232
	10087721

Elimina todo los digitos::

	$ sed 's/[0-9]//g' file1.txt 
	# Documentacion
	#de algo
	Veamos este ejemplo
	veamos este otro ejemplo

Elimina todos los caracteres en minusculas::

	$ sed 's/[a-z]//g' file1.txt 
	# D
	# 
	V  
	   
	10081551
	10081599
	10082234
	10082259
	20081134
	20081159
	30082232
	10087721

Elimina todos los caracteres en Mayusculas::

	$ sed 's/[A-Z]//g' file1.txt 
	# ocumentacion
	#de algo
	eamos este ejemplo
	veamos este otro ejemplo
	10081551
	10081599
	10082234
	10082259
	20081134
	20081159
	30082232
	10087721
Elimina todos los caracteres y numericosm, solo quedan los caracteres especiales::

	$ sed 's/[a-zA-Z0-9]//g' file1.txt 
	# 
	# 

Este es el archivo de demo::

	$ cat file1.txt 
	# Documentacion
	#de algo
	Veamos este ejemplo

	veamos este otro ejemplo
	 10081551
	10081599
	  10082234
	10082259

	20081134

	20081159

	30082232

	10087721

Eliminar todas las lineas en blanco::

	$ sed '/^$/d' file1.txt 
	# Documentacion
	#de algo
	Veamos este ejemplo
	veamos este otro ejemplo
	 10081551
	10081599
	  10082234
	10082259
	20081134
	20081159
	30082232
	10087721

Este es el archivo de demo::

	$ cat file2.txt 
	{info},
	{info},
	{info},
	{info},

Elimina el ultimo caracter coincidente de la ultima linea::

	$ sed '$ s/,$//' file2.txt 
	{info},
	{info},
	{info},
	{info}
Elimina el primer caracter coincidente de la primera linea::

	$ sed '1 s/{//' file2.txt 
	info},
	{info},
	{info},
	{info},

Este es el archivo de demo::

	$ cat file3.txt
	/dev/vgP2XT
	/dev/disk/disk4415
	/dev/disk/disk4335
	/dev/disk/disk4214
	/dev/disk/disk4413
	/dev/disk/disk4423
	/dev/disk/disk41313
	/dev/disk/disk21063
	/dev/disk/disk20702
	/dev/disk/disk21423
	/dev/disk/disk21122
	/dev/vgQ4XT

Eliminar las lineas en donde encuentre la coincidencia::

	$ sed '/vg/d' file3.txt 
	/dev/disk/disk4415
	/dev/disk/disk4335
	/dev/disk/disk4214
	/dev/disk/disk4413
	/dev/disk/disk4423
	/dev/disk/disk41313
	/dev/disk/disk21063
	/dev/disk/disk20702
	/dev/disk/disk21423
	/dev/disk/disk21122

