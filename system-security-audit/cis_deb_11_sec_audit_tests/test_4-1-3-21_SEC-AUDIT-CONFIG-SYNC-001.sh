#!/bin/bash

test_id="SEC-AUDIT-CONFIG-SYNC-001"
test_name="Ensure running and on disk audit configuration is the same"
exit_status=0

# Sprawdzenie, czy narzędzie augenrules jest dostępne
if ! command -v augenrules &> /dev/null; then
    echo "FAIL;$test_id;$test_name; - Narzędzie augenrules nie jest dostępne."
    exit 1
fi

# Wykonanie augenrules --check do sprawdzenia konfiguracji
check_result=$(augenrules --check 2>&1)

if [[ $check_result == *'No change'* ]]; then
    echo "PASS;$test_id;$test_name;"
else
    echo "FAIL;$test_id;$test_name; - Konfiguracja audytu na dysku różni się od bieżącej. Rozważ uruchomienie 'augenrules --load'."
    echo "Detale: $check_result"
    exit_status=1
fi

exit $exit_status
