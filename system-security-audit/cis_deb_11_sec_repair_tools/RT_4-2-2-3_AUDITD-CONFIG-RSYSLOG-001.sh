#!/bin/bash

# Ścieżka do pliku konfiguracyjnego journald
journald_conf="/etc/systemd/journald.conf"

# Sprawdzenie, czy opcja ForwardToSyslog jest już ustawiona na yes
if grep -qE '^\s*ForwardToSyslog=yes' "$journald_conf"; then
    echo "ForwardToSyslog jest już ustawione na 'yes'. Nie są wymagane żadne zmiany."
else
    echo "Ustawianie ForwardToSyslog na 'yes' w pliku $journald_conf."

    # Dodanie ustawienia ForwardToSyslog=yes do pliku konfiguracyjnego
    if grep -qE '^\s*ForwardToSyslog' "$journald_conf"; then
        # Jeśli linia istnieje, ale jest zakomentowana lub ma inną wartość, zamienia ją
        sed -i 's/^\s*ForwardToSyslog.*/ForwardToSyslog=yes/' "$journald_conf"
    else
        # Jeśli linia nie istnieje, dodaje ją na koniec pliku
        echo "ForwardToSyslog=yes" >> "$journald_conf"
    fi

    # Restartowanie usługi rsyslog, aby zastosować zmiany
    echo "Restartowanie usługi rsyslog..."
    systemctl restart rsyslog
    echo "Usługa rsyslog została zrestartowana. Konfiguracja została zaktualizowana."
fi
