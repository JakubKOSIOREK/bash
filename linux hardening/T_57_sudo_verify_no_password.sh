#!/bin/bash
# shellcheck source=/dev/null
source ./colorama.conf

## ---------------------------------------------------
## Verify that the user has a password
## ---------------------------------------------------
##
## Test checks if there are any users who do not have
## a password set
##
## ---------------------------------------------------
## usage: filename.sh [argument]
## ---------------------------------------------------
##
message="Verify that the users have passwords"
failure="${D_GRAY}[${RED} - ${D_GRAY}]${RESET_ALL}"
success="${D_GRAY}[${GREEN} * ${D_GRAY}]${RESET_ALL}"
error="${RED}ERROR${RESET_ALL}"

USERS=$(awk -F':' '{print $1}' /etc/passwd)

result=()
users=()
for username in $USERS; do
  com=$(sudo passwd -S "$username" | awk '{print $2}')
  if [ "$com" = NP ]; then
    result+=(1)
    users+=("$username")
  else
    result+=(0)
  fi
done

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
              if [[ "${result[*]}" =~ 1 ]]; then
                exit 1
              else
                exit 0
              fi
            ;;
            ## -v | --verbose     – test with the result
            ##                      printed on the console
            -v|--verbose)
              if [[ "${result[*]}" =~ 1 ]]; then
                echo -e "${failure} ${D_GRAY} --> ${YELLOW}${users[*]}${D_GRAY} <-- no password set ${RESET_ALL}"
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
