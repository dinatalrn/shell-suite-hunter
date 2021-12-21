#!/bin/bash

os_type(){
	case `uname` in
		Linux )
		     which yum && { echo 'centos'; return; }
		     which zypper && { echo 'opensuse'; return; }
		     which apt-get && { echo 'debian'; return; }
		     ;;
		Darwin )
		     echo 'osx';
		     return;
		     ;;
		* )
		     # Handle AmgiaOS, CPM, and modified cable modems here.
		     echo 'other';
		     return;
		     ;;
	esac
}

get_bash_file(){
	[[ "$(os_type)" = "osx" ]] && echo ".bash_profile" || echo ".bashrc"
}

installation(){
	
	if [ ! -d "$HOME/.drss" ]; then

		SCRIPTDIR=`cd "$(dirname "$0")" && pwd`
		SCRIPTDIR=`echo "$SCRIPTDIR" | sed -E 's#/[^/]+$##'`
		mv $SCRIPTDIR $HOME/.drss
		# cp -r . $HOME/.drss

	fi

	if [[ `which hunter | wc -l` -eq 0 ]]; then
		echo "Instaalando binário... "
		sudo ln -s $HOME/.drss/hunter /usr/local/bin/hunter
	fi

	BASH_FILE=`get_bash_file`
	if [ \( -z "$HUNTER_HOME" \) -a \( `grep "HUNTER_HOME" $HOME/$BASH_FILE | wc -l` -eq 0 \) ]; then
		export HUNTER_HOME=$HOME/.drss
		cat <<EOT >> $HOME/$BASH_FILE

# Definindo ENV_VAR \$HUNTER_HOME
[[ -z "\$HUNTER_HOME" ]] && export HUNTER_HOME=\$HOME/.drss
source \$HUNTER_HOME/lib/autocomplete.sh
# Fim da definição da ENV_VAR \$HUNTER_HOME

EOT

		echo ""
		echo 'Inicie uma nova sessão no terminal para usar os comandos.';
		echo ""
	fi
	
	echo 'Instalação concluída!!! \o/';
	echo ""

}

uninstallation(){

	export HUNTER_HOME=""
	BASH_FILE=`get_bash_file`
	sed -i"" "/\\\$HUNTER_HOME/d" "$HOME/$BASH_FILE";

	if [[ `which hunter | wc -l` -eq 1 ]]; then
		sudo rm -f /usr/local/bin/hunter
	fi

	if [ -d "$HOME/.drss" ]; then
		echo 'Removendo tudo... :(';
		rm -rf $HOME/.drss;
	fi
}


case $1 in
	-r) 
		uninstallation $@
	;;
	*)
		installation
	;;
esac