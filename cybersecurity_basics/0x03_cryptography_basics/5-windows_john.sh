#!/bin/bash
bash -c $'awk \'{print "user:"$0}\' "$1" > .nt\njohn --wordlist=/usr/share/wordlists/rockyou.txt --format=nt .nt >/dev/null 2>&1\njohn --show --format=nt .nt | cut -d: -f2 > 5-password.txt' bash "$1"
