#!/bin/bash

# Inicializar las matrices de errores
errores_no_existe=()
errores_directorio_adicional=()
FLAG_ERROR=0

function mostrar_ayuda {
  echo "Uso: $0 -a <archivo_estructura> -d <directorio_base>"
  echo
  echo "  -a <archivo_estructura> : Especifica el archivo de estructura"
  echo "  -d <directorio_base>    : Especifica el directorio base"
  exit 1
}

# Procesar los parámetros
while getopts "a:d:" opt; do
  case $opt in
    a)
      archivo_estructura="$OPTARG"
      ;;
    d)
      directorio_base="$OPTARG"
      ;;
    \?)
      mostrar_ayuda
      ;;
  esac
done

# Verificar que se proporcionaron ambos parámetros
if [ -z "$archivo_estructura" ] || [ -z "$directorio_base" ]; then
  mostrar_ayuda
fi

# Resto del script (sin cambios en el código)
function existe_directorio {
  local directorio="$1"
  [ -d "$directorio" ]
}

function verificar_estructura_directorios {
  while IFS= read -r directorio; do
    ruta_completa="$directorio_base/$directorio"

    if ! existe_directorio "$ruta_completa"; then
      errores_no_existe+=("[ERROR] $ruta_completa: No Existe")
      FLAG_ERROR=1
    fi
  done < "$archivo_estructura"
}


function verifica_directorios_de_mas {
  local new_dir_base="$directorio_base/$(awk -F '/' '{print $1}' "$archivo_estructura" | sort | uniq | head -n 1)"

  if [ -d "$new_dir_base" ]; then
    Estructura_Real=$(find "$new_dir_base" -type d | sort | sed "s|^$directorio_base/||")
    errores=$(diff <(echo "$Estructura_Real") <(sed 's:/$::' "$archivo_estructura") | grep '<')

    if [ -n "$errores" ]; then
      while read -r linea; do
        errores_directorio_adicional+=("[DIRECTORIO EXTRA] ${linea#< }: Directorio Adicional")
        FLAG_ERROR=1
      done <<< "$errores"
    fi
  fi
}

verificar_estructura_directorios "$archivo_estructura" "$directorio_base"
#verifica_directorios_de_mas "$archivo_estructura" "$directorio_base"

# Comprobar errores antes de imprimir
if [ "$FLAG_ERROR" -eq 1 ]; then
  echo "La estructura de directorio no es correcta. Se han encontrado errores:"
  echo
  for error in "${errores_no_existe[@]}"; do
    echo "$error"
  done
  for error in "${errores_directorio_adicional[@]}"; do
    echo "$error"
  done
else
  echo "La estructura de directorio es correcta."
fi

