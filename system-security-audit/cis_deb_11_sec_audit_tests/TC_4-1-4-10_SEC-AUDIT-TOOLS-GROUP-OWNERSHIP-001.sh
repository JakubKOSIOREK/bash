#!/bin/bash

test_id="SEC-AUDIT-TOOLS-GROUP-OWNERSHIP-001"
test_name="Ensure audit tools belong to group root"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Komunikaty o błędach

exit_status=0

# Lista narzędzi audytu do sprawdzenia
audit_tools=(
    "/sbin/auditctl"
    "/sbin/aureport"
    "/sbin/ausearch"
    "/sbin/autrace"
    "/sbin/auditd"
    "/sbin/augenrules"
)

# Sprawdzenie grupy właścicielskiej dla każdego narzędzia audytu
for tool in "${audit_tools[@]}"; do
    # Sprawdzenie grupy właścicielskiej narzędzia
    tool_group=$(stat -c "%G" "$tool")
    # Sprawdzenie, czy grupą właścicielską jest root
    if [ "$tool_group" != "root" ]; then
        test_fail_messages+=("Narzędzie audytu $tool nie należy do grupy root.")
        exit_status=1
    fi
done

# Połączenie komunikatów o błędach w jedną linię
test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
