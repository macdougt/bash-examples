#!/usr/bin/env bash
declare -A MYMAP     # Create an associative array
MYMAP[foo]=bar       # Put a value into an associative array
echo ${MYMAP[foo]}
