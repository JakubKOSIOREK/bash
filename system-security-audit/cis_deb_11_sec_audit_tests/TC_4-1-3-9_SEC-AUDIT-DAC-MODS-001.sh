#!/usr/bin/env bash

test_id="SEC-AUDIT-DAC-MODS-001"
test_name="Ensure discretionary access control permission modification events are collected"
file_name="/etc/audit/audit.rules"

script_path="$0"
test_file=$(basename "$script_path")

test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Sprawdzenie istnienia narzędzia auditctl
if ! sudo /usr/sbin/auditctl -l &> /dev/null; then
    test_fail_messages+=("Narzędzie auditctl nie jest dostępne.")
    exit_status=1
else
    UID_MIN=$(awk '/^[[:space:]]*UID_MIN[[:space:]]+([0-9]+)/{print $2}' /etc/login.defs)

    if [ -z "${UID_MIN}" ]; then
        test_fail_messages+=("Nie można ustalić UID_MIN z /etc/login.defs.")
        exit_status=1
    else
        # Załadowanie reguł do zmiennej
        loaded_rules=$(sudo /usr/sbin/auditctl -l)

        # Definicja oczekiwanych elementów reguł jako wzorców
        expected_rules_patterns=(
            "arch=b64.*chmod,fchmod,fchmodat"
            "arch=b64.*chown,fchown,lchown,fchownat"
            "arch=b32.*chmod,fchmod,fchmodat"
            "arch=b32.*lchown,fchown,chown,fchownat"
            "arch=b64.*setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr"
            "arch=b32.*setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr"
        )

        # Funkcja do sprawdzania obecności reguły
        check_rule() {
            local pattern="$1"
            echo "$loaded_rules" | grep -q -- "$pattern"
        }

        # Iteracja przez wzorce reguł i sprawdzanie ich obecności
        for pattern in "${expected_rules_patterns[@]}"; do
            if ! check_rule "$pattern"; then
                test_fail_messages+=("Oczekiwana reguła audytu nie jest załadowana: $pattern")
                exit_status=1
                break # Wyjście z pętli po pierwszym niepowodzeniu
            fi
        done
    fi
fi

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name}"
else
    test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
