#!/bin/bash
grep $(cat logs.txt | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}') logs.txt | awk -F'"' '{print $6}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}'
