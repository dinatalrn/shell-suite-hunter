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

BRANCH=`cd $SCRIPTPATH && ( git branch | grep -E "^*" | awk '{ print $2 }' )`;

self_update_git() {

    echo_warning "Buscando última versão...";

    cd $SCRIPTPATH && git fetch origin $BRANCH > /dev/null 2>&1

    [ `cd $SCRIPTPATH && git diff --name-only origin/$BRANCH | wc -l` -ne 0 ] && {
            
        echo_info "Nova versão encontrada, iniciando atualização...";

        cd $SCRIPTPATH && git pull --force origin $BRANCH > /dev/null 2>&1

        echo_success "Estou atualizado!!! \o/.";

        # Now exit this old instance
        exit 0;

    } || echo_success "Já estou na versão mais atualizada.";
        
}

self_update_git
