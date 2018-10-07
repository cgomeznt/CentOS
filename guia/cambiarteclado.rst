Cambiar la distribución del teclado - keymap layout
==================================================

Si el loadkeys command no esta en nuestra distribución instalamos el paquete kbd.::

	# yum install kbd


El siguiente ejemplo cambia de forma temporal el sistema de Keymap a Slovak.::

	# loadkeys sk
	Loading /lib/kbd/keymaps/xkb/sk.map.gz

Para listar todos los keymaps disponibles.::

	# localectl list-keymaps

Podemos filtrar.::

	# localectl list-keymaps | grep ^us

Para dejar la configuración permantente utilizamos localectl.::

	# localectl set-keymap es

Para confirmar el cambio.::

	# localectl 
	   System Locale: LANG=en_US.UTF-8
	       VC Keymap: es
	      X11 Layout: es
	       X11 Model: pc105
	     X11 Options: terminate:ctrl_alt_bksp
