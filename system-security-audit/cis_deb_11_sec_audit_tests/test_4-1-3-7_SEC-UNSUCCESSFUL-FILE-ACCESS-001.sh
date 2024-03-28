#!/usr/bin/env bash

#!/usr/bin/env bash

test_id="SEC-UNSUCCESSFUL-FILE-ACCESS-002"
test_name="Upewnij się, że nieudane próby dostępu do plików są rejestrowane"
exit_status=0
audit_dir="/etc/audit/rules.d"
auditctl_path=$(command -v auditctl)

# Sprawdzenie istnienia katalogu z regułami audytu i narzędzia auditctl
if [ ! -d "$audit_dir" ] || [ -z "$auditctl_path" ]; then
    echo "FAIL;$test_id;$test_name; - Brak katalogu z regułami audytu lub narzędzia auditctl."
    exit 1
fi

UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

# Definicja reguł do sprawdzenia
read -r -d '' rules << EOM
-a always,exit -F arch=b64 -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=${UID_MIN} -F auid!=-1 -k access
-a always,exit -F arch=b64 -S creat,open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=${UID_MIN} -F auid!=-1 -k access
-a always,exit -F arch=b32 -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=${UID_MIN} -F auid!=-1 -k access
-a always,exit -F arch=b32 -S creat,open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=${UID_MIN} -F auid!=-1 -k access
EOM

# Sprawdzanie obecności reguł
while IFS= read -r rule; do
    if ! grep -Pq -- "$(echo "$rule" | sed 's/-F arch=b[36]4//')" "$audit_dir"/*.rules &> /dev/null; then
        echo "FAIL;$test_id;$test_name; - Nie znaleziono reguły audytu: $rule"
        exit_status=1
    fi
done <<< "$rules"

# Sprawdzanie załadowanych reguł
while IFS= read -r rule; do
    if ! "$auditctl_path" -l | grep -Pq -- "$(echo "$rule" | sed 's/-F arch=b[36]4//')" &> /dev/null; then
        echo "FAIL;$test_id;$test_name; - Reguła nie jest załadowana: $rule"
        exit_status=1
    fi
done <<< "$rules"

# Raportowanie wyniku
if [ $exit_status -eq 0 ]; then
    echo "PASS;$test_id;$test_name;"
    exit 0
else
    exit $exit_status
fi
