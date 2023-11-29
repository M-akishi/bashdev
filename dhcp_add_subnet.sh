#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ejecutarse con privilegios de root."
    exit 1
fi


archive="/etc/dhcp/dhcpd.conf"

read -p "Ingrese la ip de la red : " subnet
read -p "Ingrese la mascara de red : " netmask
read -p "Ingrese la ip del router : " router
read -p "Rango de la red? : " range

text="
subnet $subnet netmask $netmask {
  option subnet-mask         $netmask;
  option routers             $router;
  range                      $range;
  option domain-name-servers $router;
}"

if [ -e "$archive" ]; then
    echo -e "$text" >> "$archive"
    echo "Subnet agregada exitosamente"
else
    echo "archivo de configuracion no existente, has instalado el servidor dhcp?"
fi

