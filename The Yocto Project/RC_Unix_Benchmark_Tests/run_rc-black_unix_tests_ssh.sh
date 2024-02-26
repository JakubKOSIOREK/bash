#!/bin/bash

# Adres hosta zdalnego, z którym chcemy się połączyć
SSH_REMOTE_HOST="username@hostname" # przykładowy adres IP lub

ROOT_DIR="." # Ścieżka do katalogu głównego

MAIN_DIR="${ROOT_DIR}" # Ścieżka do katalogu z testami

# Pobierz aktualny czas
TIMESTAMP=$(date +"%Y%m%d") # RRRRMMDD

# Pobierz tylko nazwę dystrybucji systemu
#os_name=$(ssh "$SSH_REMOTE_HOST" 'cat /etc/*release | grep -w NAME | cut -d "=" -f2' | tr -d '"' | tr ' ' '_')
os_name="RC_BLACK"

# Plik do zapisu wyników testów
REPORTS_DIR="${MAIN_DIR}/Reports"
REPORT_FILE="${REPORTS_DIR}/${os_name}_hardening_tests_results_${TIMESTAMP}.csv"

# Definicja kolorów
GREEN="\033[0;32m"
RED="\033[1;31m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
GRAY="\033[0;30m"
WHITE="\033[0;37m"
PURPLE="\033[0;35m"
BROWN="\033[0;33m"
DARK_GRAY="\033[1;90m"
LIGHT_PURPLE="\033[1;95m"
LIGHT_CYAN="\033[1;96m"
RESET="\033[0m"

# Wyświetl zebrane informacje
printf "${DARK_GRAY}OPERATING SYSTEM: ${CYAN}$os_name${RESET}\n"

# Inicjalizacja pliku raportu
echo "Status,Test ID,Test Title,Additional Info" > "$REPORT_FILE"

# Funkcja do przetwarzania wyników /RC_RED_Unix_Benchmark_Teststestów i zapisywania ich do pliku CSV
process_test_result() {
    local result=$1
    IFS=':' read -r -a array <<< "$result"
    local test_id="TC-${array[0]}"
    local test_title="${array[1]}"
    local status="${array[2]}"
    local additional_info="${array[3]}"
    local status_text=""
    local color=""

    case $status in
        0) status_text="PASS"; color=$GREEN ;;
        1) status_text="FAIL"; color=$RED ;;
        2) status_text="NOT IMPLEMENTED"; color=$DARK_GRAY ;;
        3) status_text="WARNING"; color=$YELLOW ;;
        *) status_text="UNKNOWN"; color=$RESET ;;
    esac

    # Wyświetl wynik na konsoli z kolorami
    echo -e "[ ${color}${status_text}${RESET} ] ${WHITE}$test_id${RESET} : ${PURPLE}$test_title${RESET}. ${CYAN}$additional_info${RESET}"

    # Zapisz wynik do pliku CSV
    echo "\"$status_text\",\"$test_id\",\"$test_title\",\"$additional_info\"" >> "$REPORT_FILE"
}

# Funkcja do wykonania skryptów w danym katalogu
execute_scripts_in_directory() {
    local directory=$1

    if [ "$(ls -A ${directory})" ]; then
        for script in ${directory}/*.sh; do
            result=$(ssh $SSH_REMOTE_HOST 'bash -s' < $script)
            process_test_result "$result"
        done
    else
        echo "[ NOT REQUIRED ]"
    fi
}

## 1 Initial Setup
INITIAL_SETUP="${MAIN_DIR}/01_Initial_Setup"
printf "${DARK_GRAY}1 Initial Setup${RESET}\n"

    ## 1.1 Filesystem Configuration
    FILESYSTEM_CONFIGURATION="${INITIAL_SETUP}/01_01_Filesystem_Configuration"

        ## 1.1.1 Disable unused filesystems
        DISABLE_UNUSED_FILESYSTEMS="${FILESYSTEM_CONFIGURATION}/01_01_01_Disable_unused_Filesystems"
        execute_scripts_in_directory "$DISABLE_UNUSED_FILESYSTEMS"

    execute_scripts_in_directory "$FILESYSTEM_CONFIGURATION"

    ## 1.2 Configure Software Updates
    CONFIGURE_SOFTWARE_UPDATES="${INITIAL_SETUP}/01_02_Configure_Software_Updates"
    execute_scripts_in_directory "$CONFIGURE_SOFTWARE_UPDATES"

    ## 1.3 Configure sudo
    CONFIGURE_SUDO="${INITIAL_SETUP}/01_03_Configure_sudo"
    execute_scripts_in_directory "$CONFIGURE_SUDO"

    ## 1.4 Filesystem Integrity Checking
    FILESYSTEM_INTEGRITY_CHECKING="${INITIAL_SETUP}/01_04_Filesystem_Integrity_Checking"
    execute_scripts_in_directory "$FILESYSTEM_INTEGRITY_CHECKING"

    ## 1.5 Secure Boot Settings
    SECURE_BOOT_SETTINGS="${INITIAL_SETUP}/01_05_Secure_Boot_Settings"
    execute_scripts_in_directory "$SECURE_BOOT_SETTINGS"

    ## 1.6 Additional Process Hardening
    ADDITIONAL_PROCESS_HARDENING="${INITIAL_SETUP}/01_06_Additional_Process_Hardening"
    execute_scripts_in_directory "$ADDITIONAL_PROCESS_HARDENING"

    ## 1.7 Mandatory Access Control
    MANDATORY_ACCESS_CONTROL="${INITIAL_SETUP}/01_07_Mandatory_Access_Control"
        ## 1.7.1 Configure AppArmor
        CONFIGURE_APPARMOR="${MANDATORY_ACCESS_CONTROL}/01_07_01_Configure_AppArmor"
        execute_scripts_in_directory "$CONFIGURE_APPARMOR"

    ## 1.8 Warning Banners
    WARNING_BANNERS="${INITIAL_SETUP}/01_08_Warning_Banners"

        ## 1.8.1 Command Line Warning Banners
        CMD_WARNING_BANNERS="${WARNING_BANNERS}/01_08_01_Command_Line_Warning_Banners"
        execute_scripts_in_directory "$CMD_WARNING_BANNERS"

    execute_scripts_in_directory "$WARNING_BANNERS"

    ## 1.9 Update patches
    #execute_scripts_in_directory "${INITIAL_SETUP}"

## 2 Services
SERVICES_DIR="${MAIN_DIR}/02_Services"
printf "${DARK_GRAY}2 Services${RESET}\n"

    ## 2.1 inetd Services
    INETD_SERVICES="${SERVICES_DIR}/02_01_ineted_Services"
    execute_scripts_in_directory "$INETD_SERVICES"

    ## 2.2 Special Purpose Services
    SPECIAL_PURPOSE_SERVICES="${SERVICES_DIR}/02_02_Special_Purpose_Services"

        ## 2.2.1 Time Synchronization
        TIME_SYNCHRONIZATION_DIR="${SPECIAL_PURPOSE_SERVICES}/02_02_01_Time_Synchronization"
        execute_scripts_in_directory "$TIME_SYNCHRONIZATION_DIR"

    execute_scripts_in_directory "$SPECIAL_PURPOSE_SERVICES"

    ## 2.3 Service Clients
    SERVICE_CLIENTS="${SERVICES_DIR}/02_03_Service_Clients"
    execute_scripts_in_directory "$SERVICE_CLIENTS"

## 3 Network Configuration
NETWORK_CONFIGURATION="${MAIN_DIR}/03_Network_Configuration"
printf "${DARK_GRAY}3 Network Configuration${RESET}\n"

    ## 3.1 Disable unused network protocols and devices
    DISABLE_NETWORK_PROTOCOLS_AND_DEVICES="${NETWORK_CONFIGURATION}/03_01_Disable_unused_network_protocols_and_devices"
    execute_scripts_in_directory "$DISABLE_NETWORK_PROTOCOLS_AND_DEVICES"

    ## 3.2 Network Parameters (Host Only)
    NETWORK_PARAMETERS_HOST="${NETWORK_CONFIGURATION}/03_02_Network_Parameters_Host_Only"
    execute_scripts_in_directory "$NETWORK_PARAMETERS_HOST"

    ## 3.3 Network Parameters (Host and Router)
    NETWORK_PARAMETERS_HOST_ROUTER="${NETWORK_CONFIGURATION}/03_03_Network_Parameters_Host_and_Router"
    execute_scripts_in_directory "$NETWORK_PARAMETERS_HOST_ROUTER"

    ## 3.4 Uncommon Network Protocols
    UNCOMMON_NETWORK_PROTOCOLS="${NETWORK_CONFIGURATION}/03_04_Uncommon_Network_Protocols"
    execute_scripts_in_directory "$UNCOMMON_NETWORK_PROTOCOLS"

    ## 3.5 Firewall Configuration
    FIREWALL_CONFIGURATION="${NETWORK_CONFIGURATION}/03_05_Firewall_Configuration"

        ## 3.5.1 Ensure Firewall software is installed
        FIREWALL_SOFTWARE="${FIREWALL_CONFIGURATION}/03_05_01_Ensure_Firewall_software_is_installed"
        execute_scripts_in_directory "$FIREWALL_SOFTWARE"

        ## 3.5.2 Configure UncomplicatedFirewall
        UFW_CONFIGURATION="${FIREWALL_CONFIGURATION}/03_05_02_Configure_UncomplicatedFirewall"
        #printf "${DARK_GRAY}3.5.2 Configure UncomplicatedFirewall${RESET}\n"
        #execute_scripts_in_directory "$UFW_CONFIGURATION"
        
        ## 3.5.3 Configure nftables
        NFTABLES_CONFIGURATION="${FIREWALL_CONFIGURATION}/03_05_03_Configure_nftables"
        #printf "${DARK_GRAY}3.5.3 Configure nftables${RESET}\n"
        #execute_scripts_in_directory "$NFTABLES_CONFIGURATION"

        ## 3.5.4 Configure iptables
        IPTABLES_CONFIGURATION="${FIREWALL_CONFIGURATION}/03_05_04_Configure_iptables"
        #printf "${DARK_GRAY}3.5.4 Configure iptables${RESET}\n"
        #execute_scripts_in_directory "$IPTABLES_CONFIGURATION"

        ## 3.5.5 Configure firewalld
        FIREWALLD_CONFIGURATION="${FIREWALL_CONFIGURATION}/03_05_05_Configure_firewalld"
        #printf "${DARK_GRAY}3.5.5 Configure firewalld${RESET}\n"
        #execute_scripts_in_directory "$FIREWALLD_CONFIGURATION"

## 4 Logging and Auditing
LOGGING_AND_AUDITING="${MAIN_DIR}/04_Logging_and_Auditing"
printf "${DARK_GRAY}4 Logging and Auditing${RESET}\n"

    ## 4.1 Configure System Accounting (auditd)
    AUDITD="${LOGGING_AND_AUDITING}/04_01_Configure_System_Accounting"

        ## 4.1.1 Ensure auditing is enabled
        AUDITING_ENABLED="${AUDITD}/04_01_01_Ensure_auditing_is_enabled"
        execute_scripts_in_directory "$AUDITING_ENABLED"

        ## 4.1.2 Configure Data Retention
        CONFIGURE_DATA_RETENTION="${AUDITD}/04_01_02_Configure_Data_Retention"
        execute_scripts_in_directory "$CONFIGURE_DATA_RETENTION"

    execute_scripts_in_directory "$AUDITD"

    ## 4.2 Configure Logging
    CONFIGURE_LOGGING="${LOGGING_AND_AUDITING}/04_02_Configure_Logging"
        
        ## 4.2.1 Configure rsyslog
        CONFIGURE_RSYSLOG="${CONFIGURE_LOGGING}/04_02_01_Configure_rsyslog"
        execute_scripts_in_directory "$CONFIGURE_RSYSLOG"

        ## 4.2.2 Configure journald
        CONFIGURE_JOURNALD="${CONFIGURE_LOGGING}/04_02_02_Configure_journald"
        execute_scripts_in_directory "$CONFIGURE_JOURNALD"
    
    execute_scripts_in_directory "$CONFIGURE_LOGGING"

execute_scripts_in_directory "$LOGGING_AND_AUDITING"

## 5 Access, Authentication and Authorization
printf "${DARK_GRAY}5 Access, Authentication and Authorization${RESET}\n"
ACCESS_AUTHENTICATION_AUTHORIZATION="${MAIN_DIR}/05_Access_Authentication_and_Authorization"

    ## 5.1 Configure cron
    CONFIGURE_CRON="${ACCESS_AUTHENTICATION_AUTHORIZATION}/05_01_Configure_cron"
    execute_scripts_in_directory "$CONFIGURE_CRON"

    ## 5.2 SSH Server Configuration
    SSH_CONFIGURATION="${ACCESS_AUTHENTICATION_AUTHORIZATION}/05_02_SSH_Server_Configuration"
    execute_scripts_in_directory "$SSH_CONFIGURATION"

    ## 5.3 Configure PAM
    PAM_CONFIGURATION="${ACCESS_AUTHENTICATION_AUTHORIZATION}/05_03_Configure_PAM"
    execute_scripts_in_directory "$PAM_CONFIGURATION"

    ## 5.4 User Accounts and Environment
    PAM_CONFIGURATION="${ACCESS_AUTHENTICATION_AUTHORIZATION}/05_04_User_Accounts_and_Environment"

        ## 5.4.1 Set Shadow Password Suite Parameters
        SET_SHADOW_PASSWORD_SUITE_PARAMETERS="${PAM_CONFIGURATION}/05_04_01_Set_Shadow_Password_Suite_Parameters"
        execute_scripts_in_directory "$SET_SHADOW_PASSWORD_SUITE_PARAMETERS"

    execute_scripts_in_directory "$PAM_CONFIGURATION"
    
execute_scripts_in_directory "$ACCESS_AUTHENTICATION_AUTHORIZATION"

## 6 System Maintenance
SYSTEM_MAINTENANCE="${MAIN_DIR}/06_System_Maintenance"
printf "${DARK_GRAY}6 System Maintenance${RESET}\n"
    ##  6.1 System File Permissions
    SYSTEM_FILE_PERMISIONS="${SYSTEM_MAINTENANCE}/06_01_System_File_Permissions"
    execute_scripts_in_directory "$SYSTEM_FILE_PERMISIONS"

    ##  6.2 User and Group Settings
    USER_AND_GROUP_SETTINGS="${SYSTEM_MAINTENANCE}/06_02_User_and_Group_Settings"
    execute_scripts_in_directory "$USER_AND_GROUP_SETTINGS"