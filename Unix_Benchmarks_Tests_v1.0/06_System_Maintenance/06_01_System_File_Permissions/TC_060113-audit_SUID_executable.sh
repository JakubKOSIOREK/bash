#!/bin/bash

TEST_TITLE="Audit SUID executables"
TEST_ID=060113

# Expected list of SUID executables
EXPECTED_LIST=(
    /sbin/mount.nfs
    /bin/mount.util-linux
    /bin/busybox.suid
    /bin/umount.util-linux
    /bin/su.util-linux
    /bin/su.shadow
    /usr/sbin/unix_chkpwd
    /usr/sbin/seunshare
    /usr/bin/newgidmap
    /usr/bin/at
    /usr/bin/chage
    /usr/bin/newgrp.shadow
    /usr/bin/expiry
    /usr/bin/newuidmap
    /usr/bin/gpasswd
    /usr/bin/chfn.shadow
    /usr/bin/sudo
    /usr/bin/chsh.shadow
    /usr/bin/passwd.shadow
    /usr/libexec/dbus-daemon-launch-helper
)

# Getting actual output from the find command
actual_list=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -4000)

# Check for discrepancies
extra_files=()
while IFS= read -r file; do
    if [[ ! " ${EXPECTED_LIST[*]} " =~ " ${file} " ]]; then
        extra_files+=("$file")
    fi
done <<< "$actual_list"

# Output the result
if [ ${#extra_files[@]} -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:Unexpected SUID files found"
    for file in "${extra_files[@]}"; do
        echo "  - $file"
    done
    exit 1
fi
