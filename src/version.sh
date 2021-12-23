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

FORMATTED_DATE=`date -d @$(cd $SCRIPTPATH && git log -n1 --format="%ct") "+%Y-%m-%d %H:%M:%S"`

echo_color $COLOR_YELLOW "Versão: " && echo "$FORMATTED_DATE"

DATE_CODE=`echo "$FORMATTED_DATE" | sed -E 's/[^0-9]/ /g' | sed 's/^20//'`
read -a CODE_ALPHA <<< "0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z"
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

echo_color $COLOR_YELLOW "Código: " && ( echo $BUFFER | sed 's/^.//' )
