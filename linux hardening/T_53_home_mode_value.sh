#!/bin/bash
# shellcheck source=/dev/null
source "./colorama.conf"

## ---------------------------------------------------
## Verify HOME_MODE variable
## ---------------------------------------------------
##
## Test checks if the HOME_MODE variable in the
## /etc/login.defs file is set to the given value
##
## ---------------------------------------------------
## usage: filename.sh [argument] [value]
## ---------------------------------------------------
##

home_mode=$2

message="Verify HOME_MODE variable"
failure="${D_GRAY}[${RED} - ${D_GRAY}]${RESET_ALL}"
success="${D_GRAY}[${GREEN} * ${D_GRAY}]${RESET_ALL}"
error="${RED}ERROR${RESET_ALL}"
usage="${YELLOW}usage${RESET_ALL}"

function status(){
    if [[ -z ${home_mode} ]]; then
        response=3
    else
        com=$(grep ^HOME_MODE /etc/login.defs | awk '{print $2}')
        HOME_MODE="${com: -3}"
        if [ "$HOME_MODE" -eq "$home_mode" ]; then
            response=0
        else
            response=1
        fi
    fi        
}

function aparse(){
    while [ -n "$1" ]
    do
        case "$1" in
            -h|--help)
    	        HELPTEXT=$(cat "$0"| grep "^\s*## " | sed 's/^\s*## / /')
           	    echo -e "${HELPTEXT}"
                exit 0
            ;;
            ## -s | --silent      – test with exit code output only
            -s|--silent)
                status "$@"
                if [ "$response" = 3 ];then exit 3
                elif [ "$response" = 1 ];then exit 1
                elif [ "$response" = 0 ];then exit 0
                else exit 4
                fi
            ;;
            ## -v | --verbose     – test with the result
            ##                      printed on the console
            -v|--verbose)
                status "$@"
                if [ "$response" = 3 ];then
                    echo -e "${error}: HOME_MODE value not provided"
                    echo -e "${usage}: filename.sh -v [value]"
                    exit 3
                elif [ "$response" = 1 ];then
                    echo -e  "${failure} ${D_GRAY} --> ${message} ${RESET_ALL}"
                    exit 1
                elif [ "$response" = 0 ];then
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
## 3 | NO USERNAME
## ---------------------------------------------------