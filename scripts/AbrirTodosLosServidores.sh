#!/bin/bash
function mensaje_inicial {
	clear
        echo -e $"
        Utiliza: $0 <correo-isp|dns-corp|dhcp-isp|dhcp-corp|nsproxy|logger-ntp|pic|contacto|svn|gestiondecontraseña|citrix|remedy|exchange|massmail|dnsbl|webmail|ldapweb|popimap|correo-corp>
        
        Ej. ejecuta el script acompañado del nombre del servicio que se quiera conectar.
		$0 correo-isp
		$0 dhcp-isp\n"
        exit 1
}

function correo-isp {
gnome-terminal --tab -t  Post01 -e "sshpass -p $arg2 ssh correo-postman-01.mgmt.cantv.net" \
		--tab -t  Post02 -e "sshpass -p $arg2 ssh correo-postman-02.mgmt.cantv.net" \
		--tab -t  post03 -e "sshpass -p $arg2 ssh correo-postman-03.mgmt.cantv.net" \
		--tab -t  relay01 -e "sshpass -p $arg2 ssh correo-relay-01.mgmt.cantv.net" \
		--tab -t  relay02 -e "sshpass -p $arg2 ssh correo-relay-02.mgmt.cantv.net" \
		--tab -t  mail01 -e "sshpass -p $arg2 ssh correo-mail-01.mgmt.cantv.net" \
		--tab -t  mail02 -e "sshpass -p $arg2 ssh correo-mail-02.mgmt.cantv.net" \
		--tab -t  clamav01 -e "sshpass -p $arg2 ssh correo-clamav-01.mgmt.cantv.net" \
		--tab -t  clamav02 -e "sshpass -p $arg2 ssh correo-clamav-02.mgmt.cantv.net" \
		--tab -t  clamav03 -e "sshpass -p $arg2 ssh correo-clamav-03.mgmt.cantv.net" \
		--tab -t  clamav04 -e "sshpass -p $arg2 ssh correo-clamav-04.mgmt.cantv.net" \
		--tab -t  domesp01 -e "sshpass -p $arg2 ssh correo-domesp-01.mgmt.cantv.net" \
		--tab -t  domesp02 -e "sshpass -p $arg2 ssh correo-domesp-02.mgmt.cantv.net" 
}

function dns-corp {
gnome-terminal --tab -t dns-master -e "sshpass -p $arg2 ssh dns-corp-master-01.cantv.com.ve" \
		--tab -t dns-dat-01 -e "sshpass -p $arg2 ssh dns-corp-dat-01.cantv.com.ve" \
		--tab -t dns-dat-02 -e "sshpass -p $arg2 ssh dns-corp-dat-02.cantv.com.ve" \
		--tab -t dns-nav-01 -e "sshpass -p $arg2 ssh dns-corp-nav-01.cantv.com.ve" \
		--tab -t dns-nav-02 -e "sshpass -p $arg2 ssh dns-corp-nav-02.cantv.com.ve"
}

function dhcp-isp {
gnome-terminal --tab -t dhcp-main-01 -e "sshpass -p $arg2 ssh dhcp-main-01.mgmt.cantv.net" \
		--tab -t dhcp-backup-01 -e "sshpass -p $arg2 ssh dhcp-backup-01.mgmt.cantv.net" \
		--tab -t dhcp-main-02 -e "sshpass -p $arg2 ssh dhcp-main-02.mgmt.cantv.net" \
		--tab -t dhcp-backup-02 -e "sshpass -p $arg2 ssh dhcp-backup-02.mgmt.cantv.net"
}

function dhcp-corp {
gnome-terminal --tab -t dhcp-corp01 -e "sshpass -p $arg2 ssh dhcp-corp-01.cantv.com.ve" \
		--tab -t dhcp-corp02 -e "sshpass -p $arg2 ssh dhcp-corp-02.cantv.com.ve"
}

function nsproxy {
gnome-terminal --tab -t nsproxy-01 -e "sshpass -p $arg2 ssh nsproxy-01.mgmt.cantv.net" \
		--tab -t nsproxy-02 -e "sshpass -p $arg2 ssh nsproxy-02.mgmt.cantv.net" \
		--tab -t nsproxy-03 -e "sshpass -p $arg2 ssh nsproxy-03.mgmt.cantv.net"
}

function logger-ntp {
gnome-terminal --tab -t logger-ntp-01 -e "sshpass -p $arg2 ssh logger-ntp-01.mgmt.cantv.net" \
		--tab -t logger-ntp-02 -e "sshpass -p $arg2 ssh logger-ntp-02.mgmt.cantv.net"
}

function pic {
gnome-terminal --tab -t picpw01 -e "sshpass -p $arg2 ssh admmule@picpw01.cantv.com.ve" \
		--tab -t picpw02 -e "sshpass -p $arg2 ssh muleadm@picpw02.cantv.com.ve" \
		--tab -t picpw03 -e "sshpass -p $arg2 ssh admmule@picpw03.cantv.com.ve" \
		--tab -t picpw04 -e "sshpass -p $arg2 ssh admmule@picpw04.cantv.com.ve" \
		--tab -t picpw05 -e "sshpass -p $arg2 ssh admmule@picpw05.cantv.com.ve" \
		--tab -t picpw06 -e "sshpass -p $arg2 ssh admmule@picpw06.cantv.com.ve" \
		--tab -t picpw07 -e "sshpass -p $arg2 ssh muleadm@picpw07.cantv.com.ve" \
		--tab -t picpw08 -e "sshpass -p $arg2 ssh muleadm@picpw08.cantv.com.ve" 
}

function contacto {
gnome-terminal --tab -t cddrpr01 -e "sshpass -p $arg2 ssh cddrpr01.cantv.com.ve" \
		--tab -t cddrpr02 -e "sshpass -p $arg2 ssh cddrpr02.cantv.com.ve" \
		--tab -t cdprpr01 -e "sshpass -p $arg2 ssh cdprpr01.cantv.com.ve" \
		--tab -t cdprpr02 -e "sshpass -p $arg2 ssh cdprpr02.cantv.com.ve"
}

function svn {
gnome-terminal --tab -t svnprod01 -e "sshpass -p $arg2 ssh svnprod01.cantv.com.ve" \
		--tab -t svndes01 -e "sshpass -p $arg2 ssh svndes01.cantv.com.ve" \
		--tab -t svnqa01 -e "sshpass -p $arg2 ssh svnqa01.cantv.com.ve"
}

function massmail {
gnome-terminal --tab -t massmail -e "sshpass -p $arg2 ssh massmail.mgmt.cantv.net"
}

function dnsbl {
gnome-terminal --tab -t dnsbl-01 -e "sshpass -p $arg2 ssh dnsbl-01.mgmt.cantv.net" \
		--tab -t dnsbl-02 -e "sshpass -p $arg2 ssh dnsbl-02.mgmt.cantv.net" 
}

function webmail {
gnome-terminal --tab -t webmail-01 -e "sshpass -p $arg2 ssh webmail-01.mgmt.cantv.net" \
		--tab -t webmail-02 -e "sshpass -p $arg2 ssh webmail-02.mgmt.cantv.net" \
		--tab -t webmail-03 -e "sshpass -p $arg2 ssh webmail-03.mgmt.cantv.net" \
		--tab -t webmail-04 -e "sshpass -p $arg2 ssh webmail-04.mgmt.cantv.net" \
		--tab -t webmail-05 -e "sshpass -p $arg2 ssh webmail-05.mgmt.cantv.net" \
		--tab -t webmail-06 -e "sshpass -p $arg2 ssh webmail-06.mgmt.cantv.net" \
		--tab -t webmail-07 -e "sshpass -p $arg2 ssh webmail-07.mgmt.cantv.net" \
		--tab -t webmail-08 -e "sshpass -p $arg2 ssh webmail-07.mgmt.cantv.net" 
}

function ldapweb {
gnome-terminal --tab -t ldapweb-01 -e "sshpass -p $arg2 ssh ldapweb-01.mgmt.cantv.net" \
		--tab -t ldapweb-02 -e "sshpass -p $arg2 ssh ldapweb-02.mgmt.cantv.net" 
}

function popimap {
gnome-terminal --tab -t popimap-01 -e "sshpass -p $arg2 ssh correo-popimap-01.mgmt.cantv.net" \
		--tab -t popimap-02 -e "sshpass -p $arg2 ssh correo-popimap-02.mgmt.cantv.net" \
		--tab -t popimap-03 -e "sshpass -p $arg2 ssh correo-popimap-03.mgmt.cantv.net" \
		--tab -t popimap-04 -e "sshpass -p $arg2 ssh correo-popimap-04.mgmt.cantv.net"
}

function correo-corp {
gnome-terminal --tab -t ldap-master-1-pro -e "sshpass -p $arg2 ssh ldap-master-1-pro.cantv.com.ve" \
		--tab -t ldap-slave-1-pro -e "sshpass -p $arg2 ssh ldap-slave-1-pro.cantv.com.ve" \
		--tab -t ldap-slave-2-pro -e "sshpass -p $arg2 ssh ldap-slave-2-pro.cantv.com.ve" \
		--tab -t correoweb-1-pro -e "sshpass -p $arg2 ssh correoweb-1-pro.cantv.com.ve" \
		--tab -t correoweb-2-pro -e "sshpass -p $arg2 ssh correoweb-2-pro.cantv.com.ve" \
		--tab -t correoweb-3-pro -e "sshpass -p $arg2 ssh correoweb-3-pro.cantv.com.ve" \
		--tab -t popimap-1-pro -e "sshpass -p $arg2 ssh popimap-1-pro.cantv.com.ve" \
		--tab -t popimap-2-pro -e "sshpass -p $arg2 ssh popimap-2-pro.cantv.com.ve" \
		--tab -t popimap-3-pro -e "sshpass -p $arg2 ssh popimap-3-pro.cantv.com.ve" \
		--tab -t popimap-4-pro -e "sshpass -p $arg2 ssh popimap-4-pro.cantv.com.ve" \
		--tab -t mail-1-pro -e "sshpass -p $arg2 ssh mail-1-pro.cantv.com.ve" \
		--tab -t mail-1-pro -e "sshpass -p $arg2 ssh mail-2-pro.cantv.com.ve"

}

function gestiondecontraseña {
		"rdesktop -g 90% 161.196.112.41&"
}

function citrix {
		xfreerdp -g 90% -k no --no-fastpath -d cantv calisto.cantv.com.ve& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv calirroe.cantv.com.ve& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv calice.cantv.com.ve& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv caldona.cantv.com.ve&
}

function remedy {
		xfreerdp -g 90% -k no --no-fastpath -d cantv remedy03.mgmt.cantv.net& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv remedy04.mgmt.cantv.net& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv remedy05.mgmt.cantv.net& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv wdirector01-cha.mgmt.cantv.net&
}

function exchange {
		xfreerdp -g 90% -k no --no-fastpath -d cantv exchbe01.cantv.com.ve& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv exchbe02.cantv.com.ve& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv exchbe03.cantv.com.ve& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv exchbe04.cantv.com.ve& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv exchbe05.cantv.com.ve& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv exchbe06.cantv.com.ve& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv exchbe07.cantv.com.ve& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv exchbe08.cantv.com.ve& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv exchbe09.cantv.com.ve& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv exchbe10.cantv.com.ve& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv exchfe01.cantv.com.ve& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv exchfe02.cantv.com.ve& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv exchfe03.cantv.com.ve& \
		xfreerdp -g 90% -k no --no-fastpath -d cantv exchfe04.cantv.com.ve& \
}



###############################################################
# MAIN
###############################################################
scriptname=$0
ruta_log="/var/tmp"
arg1=$1
arg2=$2

if [ -z "$arg1" ] ; then
	mensaje_inicial
else
	case $arg1 in
		correo-isp)
			correo-isp
		;;
		dns-corp)
			dns-corp
		;;
		massmail)
			massmail
		;;
		dhcp-isp)
			dhcp-isp
		;;
		dhcp-corp)
			dhcp-corp
		;;
		nsproxy)
			nsproxy
		;;
		logger-ntp)
			logger-ntp
		;;
		pic)
			pic
		;;
		contacto)
			contacto
		;;
		svn)
			svn
		;;
		dnsbl)
			dnsbl
		;;
		webmail)
			webmail
		;;
		ldapweb)
			ldapweb
		;;
		popimap)
			popimap
		;;
		correo-corp)
			correo-corp
		;;
		gestiondecontraseña)
			gestiondecontraseña
		;;
		citrix)
			citrix
		;;
		remedy)
			remedy
		;;
		exchange)
			exchange
		;;
		*)
			mensaje_inicial
		;;
	esac
fi
