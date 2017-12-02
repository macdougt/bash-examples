#!/usr/bin/env bash
# Globals work as expected


GLOBAL_VAR="Global us set to: initial"

function f() {
  echo "Running f"
  GLOBAL_VAR="Global set to: f"
}

function g() {
  echo "Running g"
  GLOBAL_VAR="Global set to: g"
}

echo $GLOBAL_VAR
f
echo $GLOBAL_VAR
g
echo $GLOBAL_VAR

