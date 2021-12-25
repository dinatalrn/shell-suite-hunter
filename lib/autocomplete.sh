#!/bin/bash

if [[ ! -z "$HUNTER_HOME" ]]; then

  _script()
  {

    _script_commands=""
    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    if [ "${#COMP_WORDS[@]}" = "2" ]; then
      _script_commands=`ls -p $HUNTER_HOME/src/ | grep -v "/" | sed 's/.sh$//'`
    fi

    COMPREPLY=( $(compgen -W "${_script_commands}" -- ${cur}) )

    return 0
  }
  complete -o nospace -o default -F _script hunter
  
fi