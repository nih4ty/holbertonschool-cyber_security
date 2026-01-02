#!/bin/bash

# Root icazəsi yoxlanışı
if [ "$EUID" -ne 0 ]; then
    echo "Bu skripti root və ya sudo ilə işə salın"
    exit 1
fi

# Arqument yoxlanışı
if [ -z "$1" ]; then
    echo "İstifadə: $0 <subnetwork və ya hostname>"
    exit 1
fi

TARGET="$1"

# Nmap scan – canlı hostların aşkarlanması
nmap "$TARGET"
