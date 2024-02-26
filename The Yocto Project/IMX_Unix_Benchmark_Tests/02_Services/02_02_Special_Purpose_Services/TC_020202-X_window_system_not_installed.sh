#!/bin/bash

TEST_TITLE="Ensure X Window System is not installed"
TEST_ID=020202

# Initialize an indicator varioable
XSERVER_PRESENT=false

# List of known X server binaries or files
known_xserver_files=(
    "/usr/bin/Xorg"
    "/etc/X11/xorg.conf"
)

#Check for X server executable and configuration files
for file in "${known_xserver_files[@]}"; do
    if [ -f "$file" ]; then
        XSERVER_PRESENT=true
        message="Found X Server file at $file"
        break # stop checking if any file is found
    fi
done

# Optionally, use the find command to search for Xorg in all directories
if ! $XSERVER_PRESENT; then
    if find / -type f -name 'Xorg' 2>/dev/null | grep -q 'Xorg'; then
        XSERVER_PRESENT=true
        message="Found X Server executable using find command"
    fi
fi

# Evaluate the ressult
if $XSERVER_PRESENT; then
    echo "$TEST_ID:$TEST_TITLE:1:$message"
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi
