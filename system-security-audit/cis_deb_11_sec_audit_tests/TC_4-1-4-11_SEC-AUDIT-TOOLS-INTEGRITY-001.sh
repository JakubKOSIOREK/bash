#!/bin/bash

test_id="SEC-AUDIT-TOOLS-INTEGRITY-001"
test_name="Ensure cryptographic mechanisms are used to protect the integrity of audit tools"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Komunikaty o błędach

exit_status=0

# Weryfikacja konfiguracji AIDE w celu ochrony integralności narzędzi audytu
aide_config=$(grep -Ps -- '(\/sbin\/(audit|au)\H*\b)' /etc/aide/aide.conf.d/*.conf /etc/aide/aide.conf)

# Sprawdzenie, czy konfiguracja AIDE zawiera narzędzia audytu z mechanizmami kryptograficznymi
if ! echo "$aide_config" | grep -q "/sbin/auditctl p+i+n+u+g+s+b+acl+xattrs+sha512"; then
    test_fail_messages+=("Narzędzie auditctl nie jest skonfigurowane do użycia mechanizmów kryptograficznych w AIDE.")
    exit_status=1
fi

if ! echo "$aide_config" | grep -q "/sbin/auditd p+i+n+u+g+s+b+acl+xattrs+sha512"; then
    test_fail_messages+=("Narzędzie auditd nie jest skonfigurowane do użycia mechanizmów kryptograficznych w AIDE.")
    exit_status=1
fi

if ! echo "$aide_config" | grep -q "/sbin/ausearch p+i+n+u+g+s+b+acl+xattrs+sha512"; then
    test_fail_messages+=("Narzędzie ausearch nie jest skonfigurowane do użycia mechanizmów kryptograficznych w AIDE.")
    exit_status=1
fi

if ! echo "$aide_config" | grep -q "/sbin/aureport p+i+n+u+g+s+b+acl+xattrs+sha512"; then
    test_fail_messages+=("Narzędzie aureport nie jest skonfigurowane do użycia mechanizmów kryptograficznych w AIDE.")
    exit_status=1
fi

if ! echo "$aide_config" | grep -q "/sbin/autrace p+i+n+u+g+s+b+acl+xattrs+sha512"; then
    test_fail_messages+=("Narzędzie autrace nie jest skonfigurowane do użycia mechanizmów kryptograficznych w AIDE.")
    exit_status=1
fi

if ! echo "$aide_config" | grep -q "/sbin/augenrules p+i+n+u+g+s+b+acl+xattrs+sha512"; then
    test_fail_messages+=("Narzędzie augenrules nie jest skonfigurowane do użycia mechanizmów kryptograficznych w AIDE.")
    exit_status=1
fi

# Połączenie komunikatów o błędach w jedną linię
test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
