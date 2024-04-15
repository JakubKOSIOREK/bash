#!/bin/bash

# Ścieżka do pliku common-password
PAM_FILE="/etc/pam.d/common-password"
# Ścieżka do pliku login.defs
LOGIN_DEFS_FILE="/etc/login.defs"

# Konfiguracja do dodania/zamiany w common-password
PAM_CORRECT="password        [success=1 default=ignore]      pam_unix.so obscure sha512 use_authtok try_first_pass remember=5"

# Konfiguracja do dodania/zamiany w login.defs
ENCRYPT_METHOD_CORRECT="ENCRYPT_METHOD SHA512"

# Aktualizacja /etc/pam.d/common-password
if grep -q "pam_unix.so" "$PAM_FILE"; then
    echo "Aktualizowanie $PAM_FILE..."
    sed -i "/pam_unix.so/d" "$PAM_FILE" # Usuwa wszystkie linie zawierające pam_unix.so
    echo "$PAM_CORRECT" >> "$PAM_FILE" # Dodaje poprawną konfigurację na końcu pliku
else
    echo "Dodawanie poprawnej konfiguracji do $PAM_FILE..."
    echo "$PAM_CORRECT" >> "$PAM_FILE"
fi

# Aktualizacja /etc/login.defs
if grep -Eiq "^ENCRYPT_METHOD" "$LOGIN_DEFS_FILE"; then
    echo "Aktualizowanie $LOGIN_DEFS_FILE..."
    sed -i "/^ENCRYPT_METHOD/c\\$ENCRYPT_METHOD_CORRECT" "$LOGIN_DEFS_FILE"
else
    echo "Dodawanie $ENCRYPT_METHOD_CORRECT do $LOGIN_DEFS_FILE..."
    echo "$ENCRYPT_METHOD_CORRECT" >> "$LOGIN_DEFS_FILE"
fi
