#!/bin/bash
IS_SERVER_RUNNING=false

papermc status | sed -e 's/\x1b\[[0-9;]*m//g' | grep -q "Status: running" && IS_SERVER_RUNNING=true
