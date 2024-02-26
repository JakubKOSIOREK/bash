#!/bin/bash

TEST_TITLE="Ensure DCCP is disabled"
TEST_ID=030401

SERVICE="dccp"

service_disabled=true

if lsmod | grep -q $SERVICE; then
    service_disabled=false
fi


if $service_disabled; then
    echo "$TEST_ID:$TEST_TITLE:0" # PASS
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:DCCP module is not disabled"
    exit 1
fi
