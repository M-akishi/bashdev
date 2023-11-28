#!/bin/bash

archive="/etc/samba/smb.conf"

read -p "ingrese el nombre de la carpeta : " namefolder
read -p "algun comentario para la carpeta? : " comment
read -p "ubicacion de la carpeta desde la raiz : " path
read -p "grupo de los que pueden acceder a la carpeta" group

folder="
[$namefolder]
comment = $comment
path = $path
public = yes
writeable = yes
write list = +$group
browseable = yes"

if [ -e "$archive" ]; then
    echo -e "$folder" >> "$archive"
    echo "carpeta creada exitosamente"
else
    echo "Carpeta no encontrada, has instalado samba?"
    exit
fi