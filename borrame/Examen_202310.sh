
#La idea de correccion seria:

#Validar la swap... como ya podria haber tenido configurada una.. 
# hay que validar que exista esto que es lo que se pidio... si hay de mas no importa...

echo "Swap esperada: 2G  (particion 1G + lv_swap 1G)"
./check_swap.sh
echo

# Validar Disco, Particiones y lv 
echo "Discos de 5G y 8G"
sudo lsblk -o NAME,SIZE,TYPE |grep -i disk

echo "\n Lista_Puntos_de_montaje=/datos/punto_1 /var/lib/docker/ /datos/multimedia /datos/repogit "
sudo vgs ; sudo lvs ; df -h |grep -Ei 'datos|docker' 
./check_mnt.sh /datos/punto_1 /var/lib/docker/ /datos/multimedia /datos/repogit
./check_size_lv_fs.sh

echo "permisos"
id lider
grep -Ei 'lider|implementador' /etc/shadow

echo
echo "archivos info"
history |grep -i  info

