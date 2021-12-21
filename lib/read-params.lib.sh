#!/bin/bash

###################################################################################################


read_with_equals(){
	P_KEY=`echo "$1" | sed -E 's/^([\-]+)([^=]+)=.*/\2/' | tr '-' '_' | awk '{print toupper($0)}'`
	P_VAL=`echo "$1" | grep -Eo "[^=]+$"`
	load_local_vars "$P_KEY" "$P_VAL"
}

read_with_space(){
	P_KEY=`echo "$1" | sed -E 's/^([\-]+)([^\-].*)$/\2/' | tr '-' '_' | awk '{print toupper($0)}'`
	P_VAL=`echo "$2" | grep -E '^[^\-]'`
	load_local_vars "$P_KEY" "$P_VAL"
}

load_local_vars(){
	if [[ "${!1}" = "@" ]]; then
		if [[ $DEBUG -eq 1 ]]; then
			echo "$1='$2'"
		fi
		eval "$1='$2'"
	elif [[ `echo "$1" | grep -Eo "^(DEBUG|DRY_RUN)$" | wc -l` -eq 1 ]]; then
		if [[ `echo "$2" | grep -Eo "^[0-1]$" | wc -l` -eq 1 ]]; then
			eval "$1='$2'"
		else
			eval "$1=1"
		fi
	fi
}


###################################################################################################