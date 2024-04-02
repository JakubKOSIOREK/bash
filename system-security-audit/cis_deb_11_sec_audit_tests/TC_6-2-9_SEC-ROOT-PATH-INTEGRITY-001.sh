#!/bin/bash

test_id="SEC-ROOT-PATH-INTEGRITY-001"
test_name="Ensure root PATH Integrity"
script_path="$0"
test_file=$(basename "$script_path")
test_fail_messages=() # Tablica na komunikaty o błędach
exit_status=0

# Pobieranie ścieżki roota
RPCV="$(sudo -Hiu root env | grep '^PATH' | cut -d= -f2)"

# Sprawdzanie na obecność pustego katalogu (::) w ścieżce
if echo "$RPCV" | grep -q "::"; then
    test_fail_messages+=("root's path contains an empty directory (::)")
    exit_status=1
fi

# Sprawdzanie na obecność kończącego dwukropka (:) w ścieżce
if echo "$RPCV" | grep -q ":$"; then
    test_fail_messages+=("root's path contains a trailing (:)")
    exit_status=1
fi

# Przechodzenie przez każdy katalog w PATH i sprawdzanie na obecność zagrożeń
for x in $(echo "$RPCV" | tr ":" " "); do
    if [ -d "$x" ]; then
        # Sprawdzanie, czy katalog jest katalogiem bieżącym (.)
        if [ "$x" == "." ]; then
            test_fail_messages+=("PATH contains current working directory (.)")
            exit_status=1
        fi
        # Pobieranie informacji o katalogu i sprawdzanie własności oraz uprawnień
        dir_info=$(ls -ldH "$x")
        owner=$(echo "$dir_info" | awk '{print $3}')
        permissions=$(echo "$dir_info" | awk '{print $1}')
        if [ "$owner" != "root" ]; then
            test_fail_messages+=("$x is not owned by root")
            exit_status=1
        fi
        if [ "${permissions:5:1}" != "-" ]; then
            test_fail_messages+=("$x is group writable")
            exit_status=1
        fi
        if [ "${permissions:8:1}" != "-" ]; then
            test_fail_messages+=("$x is world writable")
            exit_status=1
        fi
    else
        test_fail_messages+=("$x is not a directory")
        exit_status=1
    fi
done

# Kompilacja i wyświetlanie komunikatów o błędach
if [ "$exit_status" -eq 0 ]; then
    echo "PASS;${test_id};${test_file};${test_name};"
else
    test_fail_message=$(IFS='; '; echo "${test_fail_messages[*]}")
    echo "FAIL;${test_id};${test_file};${test_name};$test_fail_message"
fi

exit $exit_status
