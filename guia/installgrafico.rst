instalar un escritorio gráfico
==============================

Si requieres instalar un escritorio gráfico en un Centos 6 Minimal puedes hacerlo instalando los siguientes grupos de programas: “Desktop”, “Desktop Platform”, “X Window System” y “Fonts”.

Esto lo puedes hacer con el comento yum y el parámetro group install.::

	# yum groupinstall "Desktop" "Desktop Platform" "X Window System" "Fonts"

También con el nombre de los meta-paquetes o la llamada versión corta de estos grupos::

	# yum groupinstall basic-desktop desktop-platform x11 fonts

Reiniciar el sistema para que tenga efecto o arrancar el sistema gráfico con el comando “startx”.
