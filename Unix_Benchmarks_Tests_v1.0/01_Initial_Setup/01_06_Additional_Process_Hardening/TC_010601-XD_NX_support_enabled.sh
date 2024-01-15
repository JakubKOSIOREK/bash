#!/bin/bash

TEST_TITLE="Ensure XD/NX support is enabled"
TEST_ID=010601
JOURNALCTL_CMD="journalctl"
DMESG_FILE="/var/log/dmesg"
PROC_CMDLINE="/proc/cmdline"
PROC_CPUINFO="/proc/cpuinfo"

# Check if journalctl is available and use it if possible
if command -v $JOURNALCTL_CMD >/dev/null 2>&1; then
    if $JOURNALCTL_CMD | grep -q 'NX (Execute Disable) protection: active'; then
        echo "$TEST_ID:$TEST_TITLE:0:NX/XD protection is active"
        exit 0
    else
        echo "$TEST_ID:$TEST_TITLE:1:NX/XD protection is not active"
        exit 1
    fi
# Fallback to other methods if journalctl is not available
else
    if [[ -n $(grep noexec[0-9]*=off $PROC_CMDLINE) || \
          -z $(grep -E -i ' (pae|nx) ' $PROC_CPUINFO) || \
          -n $(grep '\sNX\s.*\sprotection:\s' $DMESG_FILE | grep -v active) ]]; then
        echo "$TEST_ID:$TEST_TITLE:1:NX Protection is not active"
        exit 1
    else
        echo "$TEST_ID:$TEST_TITLE:0"
        exit 0
    fi
fi
