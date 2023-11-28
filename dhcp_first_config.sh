#!/bin/bash

archive="/etc/dhcp/dhcpd.conf"

preconf="ddns-update-style interim;\ndefault-leade-time 600;\nmax-lease-time 7200;"

read -p "Ingrese la ip de la red : " subnet
read -p "Ingrese la mascara de red : " netmask
read -p "Ingrese la ip del router : " router
read -p "Rango de la red? : " range

text="
subnet $subnet netmask $netmask {
  option subnet-mask  $netmask;
  option routers      $router;
  range               $range;
  option domain-name-servers $router;
}"

if [ -e "$archive" ]; then
    echo -e "$preconf" >> "$archive"
    echo -e "$text" >> "$archive"
    echo "Primera configuracion creada exitosamente"
else
    echo "archivo de configuracion no existente, ha instalado el servidor?"
fi

