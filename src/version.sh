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