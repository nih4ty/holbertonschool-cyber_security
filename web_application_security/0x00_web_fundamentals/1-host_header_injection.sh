#!/bin/bash
curl -sS -i -X POST -H "Host: $1" -H "X-Forwarded-Host: $1" -H "Content-Type: application/x-www-form-urlencoded" --data "$3" "$2"
