#!/usr/bin/env bash

test_id="TEST-001"
test_name="Control test script"
script_path="$0"
test_file=$(basename "$script_path")

echo "N/A ;${test_id};${test_file};${test_name};wiadomość dodatkowa"
exit 0