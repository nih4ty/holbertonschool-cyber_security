#!/bin/bash
bash -c $'john --wordlist=/usr/share/wordlists/rockyou.txt --format=nt "$1" >/dev/null 2>&1\njohn --show --format=nt "$1" | cut -d: -f2 > 5-password.txt' bash "$1"
