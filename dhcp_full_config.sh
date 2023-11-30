#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ejecutarse con privilegios de root."
    exit 1
fi

# Verificar si el servicio DHCP está instalado
if command -v systemctl &> /dev/null && systemctl list-units --type=service --all | grep 'dhcpd'; then
    echo "El servidor DHCP (dhcpd) está instalado."

    # Verificar si el servicio DHCP está en ejecución
    if systemctl is-active --quiet dhcpd; then
        echo "El servidor DHCP (dhcpd) está en ejecución."
    else
        echo "¡Atención! El servidor DHCP (dhcpd) está instalado pero apagado."
    fi
else
    echo "El servidor DHCP (dhcpd) no está instalado."
fi
