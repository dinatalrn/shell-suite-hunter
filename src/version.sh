#!/bin/bash

# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPTPATH=`dirname $SCRIPT`
# Script name only
SCRIPTNAME=`echo $0 | grep -Eo "[^\/]+$"`

# Ajuste para identificar o root do projeto
SCRIPTPATH=`echo "$SCRIPTPATH" | sed -E 's#/[^/]+$##'`

source $SCRIPTPATH/lib/echo-color.lib.sh

read -a CODE_ALPHA <<< "0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z"
FORMATTED_DATE=`date -d @$(cd $SCRIPTPATH && git log -n1 --format="%ct") "+%Y-%m-%d %H:%M:%S"`

show_info(){

	echo_color $COLOR_LIGHT_GREEN "Versão: " && echo "$FORMATTED_DATE"

	DATE_CODE=`echo "$FORMATTED_DATE" | sed -E 's/[^0-9]/ /g' | sed 's/^20//'`
	BUFFER=""
	for IT in $DATE_CODE; do
		ITWZ=`echo "$IT 0" | awk '{print $1 + $2}'`
		BUFFER="${BUFFER}."
		if [[ $ITWZ -ge 36 ]]; then
			ITWZ=`awk '{print $1 - $2}' <<< "$ITWZ 36"`
			BUFFER="${BUFFER}z"
		fi
		BUFFER="${BUFFER}${CODE_ALPHA[$ITWZ]}"
	done
	echo_color $COLOR_LIGHT_GREEN "Código: " && ( echo $BUFFER | sed 's/^.//' )

}

decode_version(){
	if [[ "$1" != "" ]]; then
		if [[ `echo "$1" | grep -E "^([0-9a-z]{1,2}\.){5}[0-9a-z]{1,2}\$" | wc -l` -eq 1 ]]; then

			valueOf(){
				FACTOR="0"
				VALUE="$1"
				if [[ `grep -E "^z[0-9a-z]\$" <<< $1 | wc -l` -eq 1 ]]; then
					FACTOR="36"
					VALUE=`sed 's/^z//' <<< "$1"`
				fi
				for i in "${!CODE_ALPHA[@]}"; do
				   if [[ "${CODE_ALPHA[$i]}" = "${VALUE}" ]]; then
				       RET=`awk '{print $1 + $2}' <<< "${i} ${FACTOR}"`
				       [[ $RET -lt 10 ]] && echo "0$RET" || echo "$RET"
				   fi
				done
			}

			CODE_DATA=""
			for IT in `echo "$1" | sed 's/\./ /g'`; do
				CODE_DATA="$CODE_DATA $(valueOf "$IT")"
			done
			DECODED=`sed -E 's/^ ([0-9]{2}) ([0-9]{2}) ([0-9]{2}) ([0-9]{2}) ([0-9]{2}) ([0-9]{2})/20\1-\2-\3 \4:\5:\6/' <<< $CODE_DATA`
			echo_color $COLOR_LIGHT_BLUE "Versão: " && echo -n "$DECODED" && echo_color $COLOR_LIGHT_BLUE " (decodificada) \n" 
		fi
	fi
}

show_info $@
decode_version $@