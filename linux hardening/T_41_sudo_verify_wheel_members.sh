#!/bin/bash
# shellcheck source=/dev/null
source ./colorama.conf

## ---------------------------------------------------
## Verify group wheel members
## ---------------------------------------------------
##
## Test checks whether users belonging to the wheel
## group are on the list of users allowed to manage
## the system from the administrator level
##
## ---------------------------------------------------
## usage: filename.sh [argument]
## ---------------------------------------------------
##

message="verify group wheel members"
wheel_members_list=(
    "username_01"
    "username_02"
    "username_03"
    )

#output=$(getent group wheel | awk -F: '{print $4}' | tr , '\n')
output=$(sudo groupmems -g wheel -l)
result=()
users=()

failure="${D_GRAY}[${RED} - ${D_GRAY}]${RESET_ALL}"
success="${D_GRAY}[${GREEN} * ${D_GRAY}]${RESET_ALL}"
error="${RED}ERROR${RESET_ALL}"

for username in $output;do
    if [[ ${wheel_members_list[*]} =~ (^|[[:space:]])$username($|[[:space:]]) ]];then
        result+=(0)
    else
        result+=(1)
        users+=("$username")
    fi
done

function aparse(){
    while [ -n "$1" ]
    do
        case "$1" in
            -h|--help)
    	        HELPTEXT=$(cat "$0" | grep "^\s*## " | sed 's/^\s*## / /')
           	    echo -e "${HELPTEXT}"
                exit 0
            ;;
            ## -s | --silent      – test with exit code output only
            -s|--silent)
                if [[ "${result[*]}" =~ 1 ]]; then exit 1
                else exit 0 ; fi
            ;;
            ## -v | --verbose     – test with the result
            ##                      printed on the console
            -v|--verbose)
                if [[ "${result[*]}" =~ 1 ]]; then
                    echo -e "${failure} ${D_GRAY} --> ${YELLOW}${users[*]}${D_GRAY} <-- are not authorized ${RESET_ALL}"
                    exit 1
                else
                    echo -e  "${success} ${D_GRAY} --> ${message} ${RESET_ALL}"
                    exit 0
                fi
            ;;
        esac
        shift
    done
}
aparse "$@"

echo -e "${error}: argument not selected"
echo "Type -h | --help for more information"
exit 2
## ---------------------------------------------------
## Exit code:
## 0 | PASS
## 1 | FAULT
## 2 | NO ARGUMENT
## ---------------------------------------------------
