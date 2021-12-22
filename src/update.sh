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

    echo_info "Searching the latest version...";

    cd $SCRIPTPATH && git fetch origin $BRANCH;

    [ `cd $SCRIPTPATH && git diff --name-only origin/$BRANCH | wc -l` -ne 0 ] && {

        if [[ $# -eq 0 ]]; then
            
            echo_info "Found a new version of me, updating myself...";

            cd $SCRIPTPATH && git pull --force origin $BRANCH

            echo_success "I'm updated!!! \o/.";

        else

            echo_error ">>> Problem!! <<<";
            exit 1;

        fi

        # Now exit this old instance
        exit 0;

    } || echo_success "Already the latest version.";
        
}

self_update_git $@;
