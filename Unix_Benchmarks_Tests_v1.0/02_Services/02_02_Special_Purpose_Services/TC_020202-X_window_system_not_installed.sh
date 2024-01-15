#!/bin/bash

TEST_TITLE="Ensure X Window System is not installed"
TEST_ID=020202
PACKAGES="xserver|lightdm|gdm|kdm"

# No package manager message
NO_PACKAGE_MANAGER="No installed package manager. Please install one of the package managers (dpkg, rpm, yum, dnf) and repeat the test."

if command -v dpkg &>/dev/null; then
    PACKAGE_STATUS=$(dpkg -l | grep -E "$PACKAGES")
elif command -v rpm &>/dev/null; then
    PACKAGE_STATUS=$(rpm -q xorg-x11-server-Xorg xorg-x11-xinit)
else
    echo "$TEST_ID:$TEST_TITLE:2:$NO_PACKAGE_MANAGER"
    exit 2
fi

if [ -z "$PACKAGE_STATUS" ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1"
    exit 1
fi
