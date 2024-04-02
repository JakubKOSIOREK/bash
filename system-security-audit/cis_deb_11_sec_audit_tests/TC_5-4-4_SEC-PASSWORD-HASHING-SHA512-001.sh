#!/usr/bin/env bash

test_id="SEC-PASSWORD-HASHING-SHA512-001"
test_name="Ensure password hashing algorithm is SHA-512"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Funkcja do sprawdzenia, czy opcja sha512 jest obecna dla pam_unix.so
check_sha512_option() {
    local config_line=$1
    if [[ "$config_line" =~ pam_unix\.so ]]; then
        if [[ "$config_line" =~ sha512 ]]; then
            return 0
        else
            return 1
        fi
    fi
    return 2
}

# Sprawdzenie konfiguracji pam_unix.so w common-password
config_lines=$(grep -E '^\s*password\s+(\S+\s+)+pam_unix\.so\s+' /etc/pam.d/common-password)

# Jeśli konfiguracja pam_unix.so nie została znaleziona
if [ -z "$config_lines" ]; then
    test_fail_messages+=("pam_unix.so not configured in /etc/pam.d/common-password.")
    exit_status=1
else
    # Sprawdzenie każdej linii pod kątem opcji sha512
    while read -r line; do
        if ! check_sha512_option "$line"; then
            test_fail_messages+=("SHA-512 hashing not configured for pam_unix.so. Found line: $line")
            exit_status=1
            break
        fi
    done <<< "$config_lines"
fi

# Tworzenie jednego komunikatu o błędzie
test_fail_message=$(IFS=';'; echo "${test_fail_messages[*]}")

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_file;$test_name;"
else
    echo "FAIL;$test_id;$test_file;$test_name;$test_fail_message"
fi

exit $exit_status
