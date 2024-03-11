#!/bin/bash
IS_SERVER_RUNNING=false

ps aux | grep "java" | grep -q "\(bukkit\|paper\|purpur\|spigot\)" && IS_SERVER_RUNNING=true
