#!/bin/bash

cp ./tzk_szgdk_config_files/sysctl.d/forwarding.conf /etc/sysctl.d/forwarding.conf
chmod 644 /etc/sysctl.d/forwarding.conf

sysctl -p /etc/sysctl.d/forwarding.conf
