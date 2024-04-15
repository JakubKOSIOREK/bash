#!/bin/bash

cp ./tzk_szgdk_config_files/sysctl.d/rp-filter.conf /etc/sysctl.d/rp-filter.conf
chmod 644 /etc/sysctl.d/rp-filter.conf

sysctl -p /etc/sysctl.d/rp-filter.conf

