#!/bin/bash

TEST_TITLE="Audit SUID executables"
TEST_ID=060113

# Expected list of SUID executables
EXPECTED_LIST=(
    "/bin/mount.util-linux"
    "/bin/busybox.suid"
    "/bin/umount.util-linux"
    "/bin/su.util-linux"
    "/bin/su.shadow"
    "/usr/sbin/unix_chkpwd"
    "/usr/bin/newgidmap"
    "/usr/bin/chage"
    "/usr/bin/newgrp.shadow"
    "/usr/bin/expiry"
    "/usr/bin/newuidmap"
    "/usr/bin/gpasswd"
    "/usr/bin/chsh.shadow"
    "/usr/bin/passwd.shadow"
    "/usr/libexec/dbus-daemon-launch-helper"
    "/bin/busybox.suid"
    "/usr/bin/chsh.shadow"
    "/usr/bin/chfn.shadow"
)

# Getting actual output from the find command
actual_list=$(find / -perm /4000 2>/dev/null)

# Check for discrepancies
extra_files=()
while IFS= read -r file; do
    if [[ ! " ${EXPECTED_LIST[@]} " =~ " ${file} " ]]; then
        extra_files+=("$file")
    fi
done <<< "$actual_list"

# Output the result
if [ ${#extra_files[@]} -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:Unexpected SUID files found -> ${extra_files[*]}"
    exit 1
fi