#!/bin/bash

pairs=("XXBTZEUR")

trades_url="https://api.kraken.com/0/public/Trades?pair=%s&since=%d"
since=0
nord=0

function get_last() {
	curl -s "https://api.kraken.com/0/public/Trades?pair=XXBTZEUR&since=0" | jq .result.last | xargs
}

function get_data() {
    # global nord
    # global size
	url=$(printf $trades_url $1 $2)
	raw=$(curl -s $url)
	if [ -f "$PWD/data/KRAKEN.$1.$nord.csv" ];then
        filesize=$(echo "$PWD/data/KRAKEN.$1.$nord.csv" | wc -l)
    else
        filesize=0
    fi
    [ -n $filesize ] && [ $filesize -gt 10000 ] && let nord++
    # nord=$(ls -l $PWD/data/KRAKEN* | wc -l)
	since=$(echo $raw | jq .result.last | xargs)
	data=($(curl -s "$url" | jq ".result.$1  |.[] | .[0,1,2]" |xargs | sed 's/[1][0-9]\{9\}[\.][0-9]\{1,4\}/&\n/g'  | sed 's/^[ ]//g' | sed 's/[\.][0-9]\{1,4\}$//g' | tr ' ' ',' | csvtool col 1,2,3 - | head -n-1 >> "$PWD/data/KRAKEN.$1.$nord.csv"))
    # data=("$(echo $raw | jq ".result.$1| .[] | .[0,1,2]" | xargs | sed 's/([1][0-9]\{9\}[\.][0-9]\{1,4\}/&\n/g' | sed 's/^[ ]//g' | sed 's/[\.][0-9]\{1,4\}$/\n/g' | tr ' ' ',' | csvtool col 1,2,3 - | tail -n-1 >> "$PWD/data/KRAKEN.$1.$nord.csv")")
	echo "$2" > "$PWD/data/KRAKEN.LAST.$1.txt"
}

# | xargs | sed 's/([1][0-9]\{9\}[\.][0-9]\{1,4\}/&\n/g' | sed 's/^[ ]//g' | sed 's/[\.][0-9]\{4\}$//g' | tr ' ' ',' | csvtool col 1,2,3 - | head -n-1)"

clear
echo " - KRAKEN CSV DATAREC - "
echo
echo "Iniciando el proceso de obtencion de datos para los pares indicados en el fichero de configuracion."
echo
while [ -n "$since" ]; do
	get_data "${pairs[0]}" "$since"
	echo "[$(date +'%X %x')] Last: $(date -d @${since::10} +'%X %x')"
	sleep 3
done
echo
echo "Finalizada la obtención de datos."
# curl -s "https://api.kraken.com/0/public/Trades?pair=XXBTZEUR&since=0" | jq  ".result.XXBTZEUR | .[] | .[0,1,2]    | xargs | sed 's/[1][0-9]\{9\}[\.][0-9]\{1,4\}/&\n/g' | sed 's/^[ ]//g' | sed 's/ $//g' | tr ' ' ',' | sed 's/[\.][0-9]\{1,4\}$//g'
