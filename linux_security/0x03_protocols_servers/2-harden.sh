#!/bin/bash
find / -type d -xdev -perm -0002 -print -exec chmod o-w {} + 2>/dev/null
