#!/bin/bash
DEBUG=1

function debug() {
	[ $DEBUG -eq 1 ] && echo "[DEBUG] $*"
}

PERIOD=5
PAIR='XETHZEUR'
SINCE=0

URL="https://api.kraken.com/0/public/OHLC?pair=%s&interval=%s&since=%s"

debug "Leyendo argumentos..."
if [ -n "$1" ]; then
	PAIR=$1
	debug "Detectado par $PAIR..."
	if [ -n $2 ]; then
		PERIOD=$2
		debug "Especificado periodo de $PERIOD miutos ..."
		# if [ -n $3 ]; then
		# 	SINCE=$3
		# 	FECHA=$(date -d @$SINCE +"%X %x")
		# 	debug "Especificada fecha/hora de inicio de lectura de datos: $FECHA."
		# fi
	fi
fi

debug "Comprobando existencia del directorio de datos."
DATADIR="$PWD/kraken.data"
[ -d "$DATADIR" ] || (mkdir "$DATADIR" && debug "Creado directorio de datos, al no detectarse ninguno en la ruta actual.")

FILENAME="$DATADIR/$PAIR.$PERIOD.KRAKEN.csv"
debug "Comprobando existencia del fichero de datos $FILENAME."
if [ -f "$FILENAME" ]; then
	debug "Detectado fichero con datos del par $PAIR. Se va a continuar desde el punto donde se interrumpió. Si no desea esto, borre el fichero $FILENAME y vuelva a ejecutar este comando."
	SINCE=$(tail -n 1  $FILENAME)
	if [ $SINCE -le 0 ]; then
		debug "El fichero existe pero no contiene una marca de ultima lectura valida, el fichero va  a ser eliminado."
		echo
		debug "Para continuar pulse ENTER, para evitarlo pulse CTRL+C"
		read a
		rm "$FILENAME"
	else
		debug "Creando fichero temporal ..."
		TMPFILE="$RAND.tmp"
		head -n -1 "$FILENAME" > "$TMPFILE"
		rm "$FILENAME"
		mv "$TMPFILE" "$FILENAME"
		OLDTIME=$(date -d @$SINCE +'%X %x')
		debug "Se comenzara a leer datos desde la fecha $OLDTIME."
	fi
fi


debug "Comprobando conexión con Kraken.com ..."
wget -q  -T 5 --spider "https://api.kraken.com/0/public/Time"
if [ $? -ne 0 ];then
	echo "ERROR: no se pudo contectar con Kraken.com."
	exit 1
fi
debug "Leyendo datos desde Kraken.com ..."

OHLC=$(curl -s $(printf "$URL\n" "$PAIR" "$PERIOD" "$SINCE")) || echo "ERROR: No se pudo leer los datos, compruebe su conexion a internet, y vuelva a intentarlo mas tarde."
debug "Filtrando datos y volcandolos en $FILENAME ..."
echo "$OHLC" | jq .result.$PAIR[0:] | tr -d '\n' | xargs | sed 's/],/\n/g' | tr -d '[]' | sed 's/, /,/g' | sed 's/^  //g' >> "$FILENAME" && echo $(echo "$OHLC" | jq .result.last) >> "$FILENAME" || (echo "ERROR: los datos obtenidos no son validos." && exit 2)
echo
echo
debug "DATOS OBTENIDOS CON EXITO"

