#!/usr/bin/env bash

test_id="SEC-PRIV-COMMANDS-COLLECTED-001"
test_name="Ensure use of privileged commands are collected"
exit_status=0
privileged_cmds_count=0
privileged_cmds_not_audited_count=0

# Sprawdzanie istnienia katalogu z regułami audytu
if [ ! -d "/etc/audit/rules.d/" ]; then
    echo "FAIL;$test_id;$test_name; - Katalog /etc/audit/rules.d/ nie istnieje."
    exit 1
fi

echo "Rozpoczęcie sprawdzania uprzywilejowanych poleceń..."

# Iteracja po partycjach, które nie są zamontowane z opcjami noexec lub nosuid
partitions=$(findmnt -n -l -k -it $(awk '/nodev/ { print $2 }' /proc/filesystems | paste -sd,) | grep -Pv "noexec|nosuid" | awk '{print $1}')

for partition in $partitions; do
    # Wyszukiwanie plików uprzywilejowanych na partycji
    privileged_files=$(find "$partition" -xdev \( -perm -4000 -o -perm -2000 \) -type f 2>/dev/null)

    for file in $privileged_files; do
        if grep -q "$file" /etc/audit/rules.d/*.rules 2>/dev/null; then
            ((privileged_cmds_count++))
        else
            ((privileged_cmds_not_audited_count++))
        fi
    done
done

# Sprawdzanie, czy wszystkie uprzywilejowane polecenia są objęte regułami audytu
if [ "$privileged_cmds_not_audited_count" -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
else
    echo "FAIL;$test_id;$test_name; - Nieobjęte regułami: $privileged_cmds_not_audited_count."
    exit_status=1
fi

exit $exit_status
