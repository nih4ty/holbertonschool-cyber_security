#!/bin/bash
john --wordlist=<(zcat -f /usr/share/wordlists/rockyou.txt.gz) --format=raw-md5 --pot=4.pot "$1" >/dev/null 2>&1
john --show --format=raw-md5 --pot=4.pot "$1" | cut -d: -f2 > 4-password.txt

