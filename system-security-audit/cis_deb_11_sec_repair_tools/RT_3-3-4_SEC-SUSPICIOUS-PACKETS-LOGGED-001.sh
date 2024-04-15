#!/bin/bash

cp ./tzk_szgdk_config_files/sysctl.d/log-martians.conf /etc/sysctl.d/log-martians.conf
chmod 644 /etc/sysctl.d/log-martians.conf

sysctl -p /etc/sysctl.d/log-martians.conf