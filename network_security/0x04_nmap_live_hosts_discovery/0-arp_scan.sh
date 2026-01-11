#!/bin/bash

# Check if subnet argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <subnetwork>"
  exit 1
fi

# Run Nmap ARP scan without port scanning
sudo nmap -PR -sn "$1"
