#!/bin/bash
sleep 10

case $1 in
    start)
    echo "Se procede a montar el RamDisk"
    mount -t tmpfs -o size=10m tmpfs /var/cache/nrsd 
    ;;
    stop)
    echo "se baja el RamDisk"
    umount /var/cache/nrsd 
    ;;
    *)
    ;;
esac
