#!/bin/bash
# shellcheck source=/dev/null
source ./colorama.conf

## ---------------------------------------------------
## Verify directory and files permission
## ---------------------------------------------------
##
## Test checks what permissions are granted to the
## newly created directory and file
##
## ---------------------------------------------------
## usage: filename.sh [argument]
## ---------------------------------------------------
##

var01=600 # file        -rw-------
var02=700 # directory   drwx------

tmp="/tmp"
f_name="testFile"
d_name="testDir"
message="Verify directory and files permission"

file="$tmp/$f_name"
dir="$tmp/$d_name"
failure="${D_GRAY}[${RED} - ${D_GRAY}]${RESET_ALL}"
success="${D_GRAY}[${GREEN} * ${D_GRAY}]${RESET_ALL}"
error="${RED}ERROR${RESET_ALL}"

function file-permissions(){
    touch $file
    f_com=$(stat -c =%a "$file")
    file_perm="${f_com: -3}"
    if [ -f "$file" ] ; then rm -f "$file"; fi
    if [ "$file_perm" == "$var01" ]; then
        return 0
    else
        return 1
    fi
}

function dir-permissions(){
    mkdir $dir
    d_com=$(stat -c =%a "$dir")
    dir_perm="${d_com: -3}"
    if [ -d "$dir" ] ; then rmdir "$dir"; fi
    if [ "$dir_perm" == "$var02" ]; then
        return 0
    else
        return 1
    fi
}

function aparse(){
    while [ -n "$1" ]
    do
        case "$1" in
            -h|--help)
    	        HELPTEXT=$(cat "$0"| grep "^\s*## " | sed 's/^\s*## / /')
           	    echo -e "${HELPTEXT}"
                del_file
                del_dir
                exit 0
            ;;
            ## -s | --silent      – test with exit code output only
            -s|--silent)
                if [ $f_perm_ec == 0 ] && [ $d_perm_ec == 0 ]; then
                    exit 0
                elif [ $f_perm_ec == 1 ] && [ $d_perm_ec == 0 ]; then
                    exit 11
                elif [ $f_perm_ec == 0 ] && [ $d_perm_ec == 1 ]; then
                    exit 12
                else
                    exit 1
                fi
            ;;
            ## -v | --verbose     – test with the result
            ##                      printed on the console
            -v|--verbose)
                if [ $f_perm_ec == 0 ] && [ $d_perm_ec == 0 ]; then
                    echo -e  "${success} ${D_GRAY} --> ${message} ${RESET_ALL}"
                    exit 0
                elif [ $f_perm_ec == 1 ] && [ $d_perm_ec == 0 ]; then
                    echo -e "${failure} ${D_GRAY} --> ${YELLOW}${file_perm[*]}${D_GRAY} <-- file permission state ${RESET_ALL}"
                    exit 11
                elif [ $f_perm_ec == 0 ] && [ $d_perm_ec == 1 ]; then
                    echo -e "${failure} ${D_GRAY} --> ${YELLOW}${dir_perm[*]}${D_GRAY} <-- directory permission state ${RESET_ALL}"
                    exit 12
                else
                    echo -e  "${failure} ${D_GRAY} --> ${message} ${RESET_ALL}"
                    exit 1
                fi
            ;;
        esac
        shift
    done
}

file-permissions; f_perm_ec=$?
dir-permissions; d_perm_ec=$?

aparse "$@"

echo -e "${error}: argument not selected"
echo "Type -h | --help for more information"
exit 2
## ---------------------------------------------------
## Exit code:
## 0  | PASS
## 1  | FAULT
## 2  | NO ARGUMENT
## 11 | FAULT FILE PERMISSION
## 12 | FAULT DIR PERMISSION
## ---------------------------------------------------
