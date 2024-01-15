#!/bin/bash

TEST_TITLE="Ensure prelink is disabled"
TEST_ID=010603
PACKAGE_NAME="prelink"

# Check if the prelink package is installed
if dpkg -s $PACKAGE_NAME &> /dev/null; then
    echo "$TEST_ID:$TEST_TITLE:1:$PACKAGE_NAME is installed"
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi
