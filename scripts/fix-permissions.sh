#!/bin/bash

function setown() {
    for ITEM in "$@"; do
        sudo chown papermc:papermc -R "${ITEM}"
    done
}

function setexe() {
    for FILE in "$@"; do
        [ -h "${FILE}" ] && continue

        sudo chmod +x -R "${FILE}"
    done
}

setown "/srv/papermc/"*.jar
setown "/srv/papermc/world"
setown "/srv/papermc/plugins"

setexe "/srv/papermc/"*.jar
setexe "/srv/papermc/plugins/"*.jar
