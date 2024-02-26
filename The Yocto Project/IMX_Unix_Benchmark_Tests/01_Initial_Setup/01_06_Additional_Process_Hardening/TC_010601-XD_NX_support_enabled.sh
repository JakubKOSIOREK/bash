#!/bin/bash

TEST_TITLE="Ensure XD/NX support is enabled"
TEST_ID=010601
DMESG_FILE="/var/log/dmesg"
PROC_CMDLINE="/proc/cmdline"
PROC_CPUINFO="/proc/cpuinfo"


# Check NX support in CPU flags
if ! grep -q -E -i ' nx ' "$PROC_CPUINFO"; then
    echo "$TEST_ID:$TEST_TITLE:2:ND/NX support is not available on this CPU."
    exit 2
fi

# Check for noexec=off in kernel parameters which indicates NX might be disabled
if grep -q 'noexec[0-9]*=off' "$PROC_CMDLINE"; then
    echo "$TEST_ID:$TEST_TITLE:1:NX Protection might be disabled in kernel parameters."
    exit 1
fi

# If dmesg is available, check for NX active status
if [[ -f "$DMESG_FILE" && $(grep '\sNX\s.*\sprotection:\sactive' "$DMESG_FILE") ]];then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
elif grep -q '\sNX\s.*\sprotection:\sactive' <(dmesg) 2>/dev/null; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:NX/XD protection is not active"
    exit 1
fi
