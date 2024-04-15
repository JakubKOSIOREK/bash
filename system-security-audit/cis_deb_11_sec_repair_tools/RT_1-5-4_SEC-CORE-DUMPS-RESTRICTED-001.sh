#!/bin/bash

cp ./tzk_szgdk_config_files/limits.d/disable-core-dumps.conf /etc/security/limits.d/disable-core-dumps.conf
chmod 644 /etc/security/limits.d/disable-core-dumps.conf

cp ./tzk_szgdk_config_files/sysctl.d/disable-core-dumps.conf /etc/sysctl.d/disable-core-dumps.conf
chmod 644 /etc/sysctl.d/disable-suid-dump.conf
sysctl -w fs.suid_dumpable=0

cp ./tzk_szgdk_config_files/systemd/coredump.conf /etc/systemd/coredump.conf
chmod 644 /etc/systemd/coredump.conf
systemctl daemon-reload