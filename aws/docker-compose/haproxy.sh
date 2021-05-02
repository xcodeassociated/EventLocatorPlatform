#!/bin/bash

is_user_root () { [ "$(id -u)" -eq 0 ]; }

if is_user_root; then
    echo "info: Rootcheck ok"
else
    echo "error: Run this script as root" >&2
    exit 1
fi

haproxy -f haproxy/haproxy.cfg &
