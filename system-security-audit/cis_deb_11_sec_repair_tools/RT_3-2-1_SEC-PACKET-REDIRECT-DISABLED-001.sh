#!/bin/bash

cp ./tzk_szgdk_config_files/sysctl.d/send-redirects.conf /etc/sysctl.d/send-redirects.conf
chmod 644 /etc/sysctl.d/send-redirects.conf

sysctl -p /etc/sysctl.d/send-redirects.conf
