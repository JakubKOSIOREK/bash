#!/bin/bash

cp ./tzk_szgdk_config_files/sysctl.d/secure-redirect.conf /etc/sysctl.d/secure-redirect.conf
chmod 644 /etc/sysctl.d/secure-redirect.conf

sysctl -p /etc/sysctl.d/secure-redirect.conf
