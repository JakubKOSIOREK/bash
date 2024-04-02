#!/bin/bash

test_id="SEC-AUDIT-TOOLS-PERMISSIONS-001"
test_name="Ensure audit tools are 755 or more restrictive"
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

# Sprawdzenie uprawnień dla każdego narzędzia audytu
for tool in "${audit_tools[@]}"; do
    # Sprawdzenie uprawnień dla narzędzia
    tool_permissions=$(stat -c "%a" "$tool")
    # Sprawdzenie, czy uprawnienia są 755 lub bardziej restrykcyjne
    if [ "$tool_permissions" -lt 755 ]; then
        test_fail_messages+=("Narzędzie audytu $tool ma mniej niż 755 uprawnień.")
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
