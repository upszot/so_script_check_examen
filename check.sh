#!/bin/bash
echo "Verificacion Swap"
swapon --show --noheadings
echo
free -h
echo
sudo lvs
df -h
echo 
grep -iE 'lider|imple' /etc/shadow
echo


