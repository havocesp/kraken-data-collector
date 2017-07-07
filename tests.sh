#!/bin/bash

PAIRS=("XXBTZEUR" "XETHZEUR" "XETCZEUR" "XLTCZEUR" "XXMRZEUR" "XREPZEUR" "XXRPZEUR" "XXLMZEUR" "XEOSZEUR" "XZECZEUR" "XSTRZEUR")

function aleatorio(){
    rndtime="$RANDOM"
    lenrnd=${#rndtime}
    echo ${rndtime:$lenrnd-1:lenrnd}
}

for pair in "${PAIRS[@]}";do
    for p in "5" "15" "60";do
        bash -c "$PWD/kraken.feed.sh $pair $p"
        sleep $(aleatorio)
    done
    sleep $((aleatorio+5))
done