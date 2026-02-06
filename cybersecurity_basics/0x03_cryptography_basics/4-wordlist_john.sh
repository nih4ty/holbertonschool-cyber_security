#!/bin/bash
bash -c 'john --wordlist=<(zcat -f /usr/share/wordlists/rockyou.txt*) --format=raw-md5 "$1" >/dev/null 2>&1
john --show --format=raw-md5 "$1" | cut -d: -f2 > 4-password.txt' bash "$1"

