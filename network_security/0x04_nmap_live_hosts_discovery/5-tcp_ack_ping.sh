#!/bin/bash
sudo nmap -sn -PA -p22,80,443 $1
