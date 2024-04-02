#!/bin/bash

test_id="SEC-AUDIT-TOOLS-OWNERSHIP-001"
test_name="Ensure audit tools are owned by root"
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

# Sprawdzenie właściciela dla każdego narzędzia audytu
for tool in "${audit_tools[@]}"; do
    # Sprawdzenie właściciela narzędzia
    tool_owner=$(stat -c "%U" "$tool")
    # Sprawdzenie, czy właścicielem jest root
    if [ "$tool_owner" != "root" ]; then
        test_fail_messages+=("Narzędzie audytu $tool nie jest własnością użytkownika root.")
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
