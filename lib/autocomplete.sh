#!/bin/bash

if [[ ! -z "$HUNTER_HOME" ]]; then

  _script()
  {
    _script_commands=`ls -p $HUNTER_HOME/src/ | grep -v "/" | sed 's/.sh$//'`

    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "${_script_commands}" -- ${cur}) )

    return 0
  }
  complete -o nospace -F _script hunter
  
fi