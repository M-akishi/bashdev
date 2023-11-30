#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ejecutarse con privilegios de root."
    exit 1
fi

read -p "Bienenido a configuracion total de servidor dhcp en distribuciones RHEL, desea continuar para instalar el servicio o agregar mas subnets? s/N : " confirmation

if [ "$confirmation" = "s" ]; then
    echo "configurando.."
else
    echo "saliendo del programa.."
    exit
fi

dhcp_setup(){
    yum install dhcp
}

dhcp_first_config(){
    archive="/etc/dhcp/dhcpd.conf"

    preconf="ddns-update-style interim;\ndefault-lease-time 600;\nmax-lease-time 7200;"

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
        echo -e "$preconf" >> "$archive"
        echo -e "$text" >> "$archive"
        echo "Primera configuracion creada exitosamente"
    else
        echo "archivo de configuracion no existente, ha instalado el servidor?"
    fi
}

dhcp_add_subnet(){
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
}

# Verificar si el servicio DHCP está instalado
if [ command -v systemctl &> /dev/null && systemctl list-units --type=service --all | grep 'dhcpd' ]; then
    echo "El servidor DHCP (dhcpd) está instalado."

    # Verificar si el servicio DHCP está en ejecución
    if systemctl is-active --quiet dhcpd; then
        echo "El servidor DHCP (dhcpd) está en ejecución."
        echo "agregando otra subnet..."
        dhcp_add_subnet
    else
        echo "¡Atención! El servidor DHCP (dhcpd) está instalado pero apagado."
        echo "encendiendo servicio y agregando otra subnet"
        systemctl start dhcpd.service
        dhcp_add_subnet
    fi
else
    echo "El servidor DHCP (dhcpd) no está instalado."
    echo "instalando dhcp y creando primera configuracion"
    dhcp_setup
    dhcp_first_config
fi

