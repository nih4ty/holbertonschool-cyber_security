#!/bin/bash
# Decode IBM WebSphere XOR encoded passwords

hash="$1"

clean="${hash#\{xor\}}"

printf "%s" "$clean" | base64 -d | perl -0777 -ne '
for (unpack("C*", $_)) {
    print chr($_ ^ 0x5f);
}
print "\n";
'
