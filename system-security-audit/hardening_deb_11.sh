#!/usr/bin/env bash

# Ustawienie ścieżek do katalogów
dir_path=$(dirname "$0")
tests_dir="$dir_path/cis_deb_11_sec_repair_tools"

# Kolory ANSI (tylko do wydruku na konsolę)
green="\033[0;32m"
red="\033[0;31m"
l_gray="\033[0;37m"
d_gray="\033[1;30m"
cyjan="\033[0;36m"
reset_color="\033[0m"

# Funkcja do tymczasowego nadania uprawnień, wykonania i odebrania uprawnień do pliku skryptu
execute_script_temp_permissions() {
    local script_path="$1"
    local script_name=$(basename "$script_path")

    # Nadanie uprawnień do wykonania
    chmod +x "$script_path"

    # Wyświetlenie nazwy pliku i rozpoczęcie animacji
    echo -en "${cyjan}$script_name${reset_color}${d_gray} >"
    # Rozpoczęcie animacji w tle
    (
        while true; do
            for i in {1..3}; do
                echo -en ">"
                sleep 1
            done
            echo -ne "\b\b\b   \b\b\b"
        done
    ) & 
    local spinner_pid=$!

    # Wykonanie skryptu i przechwycenie wyjścia
    output=$("$script_path" 2>&1)
    local status=$?

    # Zatrzymanie animacji
    kill $spinner_pid
    wait $spinner_pid 2>/dev/null

    # Drukowanie wyniku wykonania
    if [ $status -eq 0 ]; then
        echo -e "${green} DONE${reset_color}"
    else
        echo -e "${red} ERROR${reset_color}: $output"
    fi

    # Odebranie uprawnień do wykonania
    chmod -x "$script_path"
}



# 1.4
execute_script_temp_permissions "$tests_dir/RT_1-4-2_SEC-GRUBCFG-PERM-001.sh"

# 1.5
execute_script_temp_permissions "$tests_dir/RT_1-5-4_SEC-CORE-DUMPS-RESTRICTED-001.sh" # /etc/sysctl.d/

# 1.6
execute_script_temp_permissions "$tests_dir/RT_1-6-1-2_SEC-APPARMOR-ENABLED-IN-BOOTLOADER-001.sh" # zmiana w /etc/default/grub

# 1.7
execute_script_temp_permissions "$tests_dir/RT_1-7-1_SEC-MOTD-CONFIGURED-PROPERLY-001.sh"
execute_script_temp_permissions "$tests_dir/RT_1-7-2_SEC-ISSUE-CONFIGURED-PROPERLY-001.sh"
execute_script_temp_permissions "$tests_dir/RT_1-7-3_SEC-ISSUE.NET-CONFIGURED-PROPERLY-001.sh"

# 2.2
execute_script_temp_permissions "$tests_dir/RT_2-2-2_SEC-AVAHI-SERVER-NOT-INSTALLED-001.sh"

# 3.1
execute_script_temp_permissions "$tests_dir/RT_3-1-1_SEC-IPV6-STATUS-DISABLED-001.sh" # zmiana w /etc/default/grub

# 3.2
execute_script_temp_permissions "$tests_dir/RT_3-2-1_SEC-PACKET-REDIRECT-DISABLED-001.sh" # /etc/sysctl.d/

# 3.3
execute_script_temp_permissions "$tests_dir/RT_3-3-1_SEC-SOURCE-ROUTED-PACKETS-DISABLED-001.sh" # /etc/sysctl.d/
execute_script_temp_permissions "$tests_dir/RT_3-3-2_SEC-ICMP-REDIRECTS-NOT-ACCEPTED-001.sh" # /etc/sysctl.d/
execute_script_temp_permissions "$tests_dir/RT_3-3-3_SEC-SECURE-ICMP-REDIRECTS-NOT-ACCEPTED-001.sh" # /etc/sysctl.d/
execute_script_temp_permissions "$tests_dir/RT_3-3-4_SEC-SUSPICIOUS-PACKETS-LOGGED-001.sh" # /etc/sysctl.d/
execute_script_temp_permissions "$tests_dir/RT_3-3-7_SEC-REVERSE-PATH-FILTERING-ENABLED-001.sh" # /etc/sysctl.d/

# 4.1
execute_script_temp_permissions "$tests_dir/RT_4-1-1-3_SEC-AUDIT-PROCESS-PRIOR-AUDITD-ENABLED-001.sh" # zmiana w /etc/default/grub
execute_script_temp_permissions "$tests_dir/RT_4-1-1-4_SEC-AUDIT-BACKLOG-LIMIT-SUFFICIENT-001.sh" # zmiana w /etc/default/grub
execute_script_temp_permissions "$tests_dir/RT_4-1-2-2_SEC-AUDIT-LOG-NOT-AUTO-DELETED-001.sh" # zmiana w /etc/audit/auditd.conf
execute_script_temp_permissions "$tests_dir/RT_4-1-2-3_SEC-AUDIT-SYSTEM-DISABLED-WHEN-LOGS-FULL-001.sh" # zmiana w /etc/audit/auditd.conf

execute_script_temp_permissions "$tests_dir/RT_4-1-4-5_SEC-AUDIT-CONFIG-FILES-PERM-001.sh"
execute_script_temp_permissions "$tests_dir/RT_4-1-4-11_SEC-AUDIT-TOOLS-INTEGRITY-001.sh"

# 4.2
execute_script_temp_permissions "$tests_dir/RT_4-2-2-3_AUDITD-CONFIG-RSYSLOG-001.sh"
execute_script_temp_permissions "$tests_dir/RT_4-2-3_SEC-LOG-FILE-PERMISSIONS-001.sh"

# 5.1
execute_script_temp_permissions "$tests_dir/RT_5-1-2_SEC-ETCCRONTAB-PERM-001.sh"
execute_script_temp_permissions "$tests_dir/RT_5-1-3_SEC-ETCCRONHOURLY-PERM-001.sh"
execute_script_temp_permissions "$tests_dir/RT_5-1-4_SEC-ETCCRONDAILY-PERM-001.sh"
execute_script_temp_permissions "$tests_dir/RT_5-1-5_SEC-ETCCRONWEEKLY-PERM-001.sh"
execute_script_temp_permissions "$tests_dir/RT_5-1-6_SEC-ETCCRONMONTHLY-PERM-001.sh"
execute_script_temp_permissions "$tests_dir/RT_5-1-7_SEC-ETCCROND-PERM-001.sh"
execute_script_temp_permissions "$tests_dir/RT_5-1-8_SEC-CRON-ACCESS-RESTRICTED-001.sh"
execute_script_temp_permissions "$tests_dir/RT_5-1-9_SEC-AT-ACCESS-RESTRICTED-001.sh"

# 5.3
execute_script_temp_permissions "$tests_dir/RT_5-3-2_SEC-SUDO-USE-PTY-001.sh"
execute_script_temp_permissions "$tests_dir/RT_5-3-3_SEC-SUDO-LOGFILE-EXISTS-001.sh"
execute_script_temp_permissions "$tests_dir/RT_5-3-7_SEC-SU-COMMAND-RESTRICTED-001.sh"

# 5.4
execute_script_temp_permissions "$tests_dir/RT_5-4-1_SEC-PASSWORD-CREATION-REQUIREMENTS-001.sh"
execute_script_temp_permissions "$tests_dir/RT_5-4-3_SEC-PASSWORD-REUSE-LIMITED-001.sh"
execute_script_temp_permissions "$tests_dir/RT_5-4-4_SEC-PASSWORD-HASHING-SHA512-001.sh"

# 5.5
execute_script_temp_permissions "$tests_dir/RT_5-5-4_SEC-DEFAULT-USER-UMASK-027-001.sh"
execute_script_temp_permissions "$tests_dir/RT_5-5-5_SEC-USER-SHELL-TIMEOUT-900-SEC-OR-LESS-001.sh"

# 6.1
execute_script_temp_permissions "$tests_dir/RT_6-1-6_SEC-SHADOW-BACKUP-PERM-001.sh"
execute_script_temp_permissions "$tests_dir/RT_6-1-9_SEC-WORLD-WRITABLE-FILES-001.sh"
execute_script_temp_permissions "$tests_dir/RT_6-1-11_SEC-NO-UNGROUPED-FILES-OR-DIRS-001.sh"

# 6.2
execute_script_temp_permissions "$tests_dir/RT_6-2-13_SEC-USER-HOME-DIRS-PERMISSIONS-001.sh"
