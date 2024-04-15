#!/bin/bash

cp ./tzk_szgdk_config_files/sysctl.d/accept-redirects.conf /etc/sysctl.d/accept-redirects.conf
chmod 644 /etc/sysctl.d/accept-redirects.conf

sysctl -p /etc/sysctl.d/accept-redirects.conf