#!/usr/bin/env bash
declare -A MYMAP     # Create an associative array
MYMAP[foo]=bar       # Put a value into an associative array
echo ${MYMAP[foo]}

MYMAP[foo2]=bar2       # Put a value into an associative array
echo ${MYMAP[foo2]}
declare -A MYMAP2[foo]     # Create an associative array

MYMAP2[foo,er]=next_level # No real multi-dimensions
echo ${MYMAP2[foo,er]}





