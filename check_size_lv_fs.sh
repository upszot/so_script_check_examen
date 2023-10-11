#!/bin/bash

declare -A lv_info_array
declare -A full_info_array
let CONT_LV=0
let CONT_FULL_INFO=0

# Función para obtener la información de los LVs
get_lv_info() {
  lv_info=($(sudo lvs --noheadings -o lv_path,lv_size --separator "#" | awk -F '#' '{print $2 "\n" $1}'))
}

# Función para imprimir el encabezado
print_header() {
	printf "%-12s | %-12s | %-12s | %-30s\n" "LV Size" "Size(df)" "FSType" "Source"
  printf "%-12s | %-12s | %-12s | %-30s\n" "------------" "------------" "------------" "------------------------------"
}

# Función para imprimir la información de los LVs
print_lv_info() {
  for ((i = 0; i < ${#lv_info[@]}; i+=2)); do
    lv_size=${lv_info[i]}
    lv_path=${lv_info[i+1]}
    printf "%-12s | %-30s\n" "$lv_size" "$lv_path"
  done
}

check_and_store_info() {
  for ((i = 0; i < ${#lv_info[@]}; i+=2)); do
    lv_size=${lv_info[i]}
    lv_path=${lv_info[i+1]}

    df_output=$(df -h --output=size,fstype,source "$lv_path" | grep -Ev 'Tipo|devtmpfs')

    if [[ -n $df_output ]]; then
      df_info=($df_output)  # Dividir la salida en una matriz
      df_size=${df_info[0]}
      df_fstype=${df_info[1]}
      df_source=${df_info[2]}

      full_info_array["$CONT_FULL_INFO,0"]="$lv_size"
      full_info_array["$CONT_FULL_INFO,1"]="$df_size"
      full_info_array["$CONT_FULL_INFO,2"]="$df_fstype"
      full_info_array["$CONT_FULL_INFO,3"]="$df_source"
      let CONT_FULL_INFO=CONT_FULL_INFO+1
    fi
  done
}

# Función para imprimir la información adicional almacenada en full_info_array
print_full_info() {

  for ((i = 0; i < CONT_FULL_INFO; i++)); do
    lv_size=${full_info_array["$i,0"]}
    df_size=${full_info_array["$i,1"]}
    fstype=${full_info_array["$i,2"]}
    source=${full_info_array["$i,3"]}
    printf "%-12s | %-12s | %-12s | %-30s\n" "$lv_size" "$df_size" "$fstype" "$source"
  done
}

# Función principal
main() {
  get_lv_info
  check_and_store_info
  print_header
  print_full_info
}

# Llamar a la función principal
main

