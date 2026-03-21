#!/bin/bash
sudo nmap -sX -p 440-450 --open $1 --packet-trace --reason
