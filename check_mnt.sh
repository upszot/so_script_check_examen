#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Uso: $0 <lista_de_paths>"
  echo "Valida si los paths estan montados y configurados en /etc/fstab"
  exit 254
fi

# Colores
GREEN='\033[32m'
RED='\033[31m'
RESET='\033[0m'

# Encabezado del cuadro
echo -e "FSTAB\t| MOUNT\t| Path"

# Itera a través de los paths proporcionados
for path in "$@"; do
  fstab=""
  mount=""

  # Guarda en una variable temporal las líneas de fstab que no están comentadas
  fstab_lines=$(grep -vE "^\s*#" /etc/fstab)

  # Verifica si el path está configurado en /etc/fstab usando awk
  if findmnt --target "$path" --fstab &> /dev/null; then
    fstab="${GREEN}X${RESET}"
  fi

  # Verifica si el path está montado
  if mount | grep -q " $path "; then
    mount="${GREEN}X${RESET}"
  fi

  # Imprime la fila del cuadro
  echo -e "$fstab\t| $mount\t| $path"
done

