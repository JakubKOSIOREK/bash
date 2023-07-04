#!/bin/bash

var1="$1" # value from commandline like ./test.sh [value]

if [[ -z $var1 ]]; then
    echo pusta
else
    echo "$var1"
fi