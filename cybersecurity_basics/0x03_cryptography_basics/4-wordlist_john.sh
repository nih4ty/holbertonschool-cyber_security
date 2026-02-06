#!/bin/bash
bash -c $'tr -d "\r" < "$1" > /tmp/hashes_clean.txt\njohn --wordlist=/usr/share/wordlists/rockyou.txt --format=Raw-SHA256 /tmp/hashes_clean.txt\njohn --show --format=Raw-SHA256 /tmp/hashes_clean.txt | awk -F: '\''NF>1{print $2}'\'' > 4-password.txt' _ "$1"
