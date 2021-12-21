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

if [[ `which git | wc -l` -eq 1 ]]; then
	echo_info "Executando comando git em '$SCRIPTPATH'... "
	#echo "$(cd $SCRIPTPATH && pwd)"
	cd $SCRIPTPATH && git $@
else
	echo ""
	echo_error "Precisa instalar o git!"
	echo ""
fi