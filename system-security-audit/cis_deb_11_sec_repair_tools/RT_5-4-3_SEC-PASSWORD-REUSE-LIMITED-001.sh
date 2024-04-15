#!/bin/bash

PAM_FILE="/etc/pam.d/common-password"
NEW_PAM_FILE="/home/administrator/system-security-audit/tzk_szgdk_config_files/pam.d/common-password"
SEARCH_PATTERN="^\s*password\s+([^#\n\r]+\s+)?pam_pwhistory\.so\s+([^#\n\r]+\s+)?remember=([5-9]|[1-9][0-9]+)\b"

# Tworzy kopię zapasową pliku
cp "$PAM_FILE" "${PAM_FILE}.backup"

# podmienia plik na nowy
cp "$NEW_PAM_FILE" "$PAM_FILE"