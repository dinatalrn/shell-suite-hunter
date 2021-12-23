#!/bin/bash

# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPTPATH=`dirname $SCRIPT`
# Script name only
SCRIPTNAME=`echo $0 | grep -Eo "[^\/]+$"`

# Ajuste para mover o build para a pasta util
SCRIPTPATH=`echo "$SCRIPTPATH" | sed -E 's#/[^/]+$##'`

###################################################################################################

source $SCRIPTPATH/lib/echo-color.lib.sh

###################################################################################################

get_content_without_binbash(){
	if [[ "$2" != "" ]]; then
		cat "$1" | sed -E 's@^#!.*@## (source '$2') @'
	else
		cat "$1" | sed -E 's@^#!.*@@'
	fi
}

for FILE_IN_SRC in `ls -p "$SCRIPTPATH/src" | grep -v "/"`; do

	FILE="$SCRIPTPATH/src/$FILE_IN_SRC"
	DIST_BUILD=`date '+%Y-%m-%d %H:%M:%S'`
	FILENAME=`echo "$FILE" | grep -Eo '[^/]+$'`
	FILEDIST="$SCRIPTPATH/dist/$FILENAME"
	[ -f "$FILEDIST" ] && rm -f "$FILEDIST"
	cp "$FILE" "$FILEDIST"

	if [[ `cat "$FILEDIST" | grep -Eo '^[^A-Za-z0-9#]*[ ]*source[ ]+.+$' | wc -l` -ne 0 ]]; then

		CONTENT_TO_FILE=`get_content_without_binbash "$FILEDIST" "$FILE"`
		echo "$CONTENT_TO_FILE" > "$FILEDIST"

		for SRC_LINE in `cat "$FILEDIST" | grep -Eo '^[^A-Za-z0-9#]*[ ]*source[ ]+.+$'`; do
			SRC_VAR=`echo "$SRC_LINE" | grep -Eo '\\$.*$'` 
			if [[ `echo "$SRC_VAR" | grep "/" | wc -l` -ne 0 ]]; then
				
				eval "SRC_RESOLVED=$SRC_VAR"

				CONTENT_TO_FILE=`get_content_without_binbash "$FILEDIST"`
				CONTENT_TO_SRC=`get_content_without_binbash "$SRC_RESOLVED" "$SRC_RESOLVED"`

				echo "$CONTENT_TO_SRC" > "$FILEDIST.tmp"
				echo -e "\n" >> "$FILEDIST.tmp"
				echo "$CONTENT_TO_FILE" >> "$FILEDIST.tmp"

				sed -E -i"" 's@^[^A-Za-z0-9#]*[ ]*(source[ ]+.+)$@###### \1 ######@' "$FILEDIST.tmp"

				rm $FILEDIST && mv "$FILEDIST.tmp" "$FILEDIST"

			fi

		done

		echo -e "#!/bin/bash \n\n# Build realizado em: $DIST_BUILD \n\n" > "$FILEDIST.tmp"
		cat "$FILEDIST" >> "$FILEDIST.tmp"
		rm $FILEDIST && mv "$FILEDIST.tmp" "$FILEDIST"
		chmod +x "$FILEDIST"
 
	fi

	echo -n "[$DIST_BUILD] " && echo_color $COLOR_LIGHT_BLUE "[INFO] " && echo "O build foi concluído para o arquivo $FILENAME"

done

chmod +x {src,dist}/*
