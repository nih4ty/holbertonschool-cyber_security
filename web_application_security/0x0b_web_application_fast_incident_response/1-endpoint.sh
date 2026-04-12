#!/bin/bash
cat logs.txt | awk '{print $7}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}'
