#!/bin/bash

function get_random_boolean() {
  local TRUE_CHANCE_PERCENTAGE=${1}
  
  if (( RANDOM % 100 < TRUE_CHANCE_PERCENTAGE )); then
    echo "true"
  else
    echo "false"
  fi
}

function get_random_element() {
    local ARGS_COUNT=${#}
    local RANDOM_ARG_INDEX=$(( RANDOM % ARGS_COUNT + 1 ))

    echo "${!RANDOM_ARG_INDEX}"
}

