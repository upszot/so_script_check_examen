#!/bin/bash
echo "Verificacion Swap"
swapon --show --noheadings
echo
free -h
