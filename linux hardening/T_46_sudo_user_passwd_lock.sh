#!/bin/bash
# shellcheck source=/dev/null
source ./colorama.conf

## ---------------------------------------------------
## Verify users password is lock
## ---------------------------------------------------
##
## Test checks password if the given user has
## a locked password.
## The password can be set, locked or deleted.
##
## ---------------------------------------------------
## usage: filename.sh [argument] [username]
## ---------------------------------------------------
##

USER=$2

message="${USER} password is lock"
failure="${D_GRAY}[${RED} - ${D_GRAY}]${RESET_ALL}"
success="${D_GRAY}[${GREEN} * ${D_GRAY}]${RESET_ALL}"
error="${RED}ERROR${RESET_ALL}"
usage="${YELLOW}usage${RESET_ALL}"

function status(){
    if [[ -z ${USER} ]]; then
        response=3
    else
        com=$(sudo passwd -S "$USER" | awk '{print $2}')
        if [ "$com" = LK ]; then
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
                    echo -e "${error}: username not selected"
                    echo -e "${usage}: filename.sh -v [username]"
                    exit 3
                elif [ "$response" = 1 ];then
                    echo -e  "${failure} ${D_GRAY} --> ${message} ${RESET_ALL}"
                    exit 1
                elif [ "$response" = 0 ];then
                    echo -e  "${success} ${D_GRAY} --> ${message} ${RESET_ALL}"
                    exit 0
                else
                    echo -e "${error}: unknown"
                    echo -e "${usage}: [username@host]$ passwd -S ${USER}"
                    echo "or do a code rewiev in script"
                    exit 4
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
## 4 | UNKNOWN
## ---------------------------------------------------