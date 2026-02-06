#!/bin/bash
bash -c $'john --wordlist=<(zcat -f /usr/share/wordlists/rockyou.txt.gz) --format=raw-md5 --pot=4.pot "$1" >/dev/null 2>&1\nawk -F: \'NR==FNR{a[$1]=$2;next}{print a[$1]}\' 4.pot "$1" > 4-password.txt' bash "$1"
