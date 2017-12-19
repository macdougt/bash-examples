#!/usr/bin/env bash

# Printing this file
echo "File content:"
echo "-------------"
cat test_bash_version.bash
echo "-------------"

echo "Output"
echo "------"

if [ "${BASH_VERSINFO}" -lt 4 ]; then
  echo "bash less than 4"
else
  echo "bash greater than or equal to 4"
fi
  
if [ "${BASH_VERSINFO}" -ge 4 ]; then
  echo "bash greater than or equal to 4"
else
  echo "bash less than 4"
fi
