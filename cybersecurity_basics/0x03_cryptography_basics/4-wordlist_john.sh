#!/bin/bash
bash -c $'john --wordlist=/usr/share/wordlists/rockyou.txt --format=raw-md5 "$1" >/dev/null 2>&1\njohn --show --format=raw-md5 "$1" | cut -d: -f2 > 4-password.txt' bash "$1"

