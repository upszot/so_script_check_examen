#!/bin/bash


# Verifica si se proporciona un argumento (path)
if [ $# -ne 1 ]; then
  echo "Uso: $0 <path a verificar>" >&2
  exit 254
fi

check_path="$1"

# Verifica si el path existe
if [ -e "$check_path" ]; then
  echo "El path '$check_path' existe."
  exit 0
else
  echo "El path '$check_path' no existe." >&2
  exit 1
fi


