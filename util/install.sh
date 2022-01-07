#!/bin/bash

SCRIPTDIR=`cd "$(dirname "$0")" && pwd`
SCRIPTDIR=`echo "$SCRIPTDIR" | sed -E 's#/[^/]+$##'`

# REPO
#DIRNAME_INSTALLATION=`cat "${SCRIPTDIR}/.git/config" | grep url | sed -E 's#^(.*)([^:/]+)[:/]([^/]+)/([^/]+).git$#.drss_\3_\4#'`
# EXEC
DIRNAME_INSTALLATION=`ls -l $SCRIPTDIR | grep -E "^\-.{8}x" | head -n 1 | sed -E 's#^(.*) ([^ ]+)$#.drss-\2#'`
#PATH
PATH_TO_INSTALLATION=$HOME/$DIRNAME_INSTALLATION

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
	echo ".$(ps -p $$ -oargs= | awk '{print $1}' | grep -Eo '[a-z][^/]+$')rc"
}

installation(){
	
	if [ ! -d "$PATH_TO_INSTALLATION" ]; then

		echo "Instalando suite... "
		mv $SCRIPTDIR $PATH_TO_INSTALLATION
		# cp -r . $PATH_TO_INSTALLATION

	fi

	if [[ `which hunter | wc -l` -eq 0 ]]; then
		echo "Instalando binário... "
		sudo ln -s $PATH_TO_INSTALLATION/hunter /usr/local/bin/hunter
	fi

	BASH_FILE=`get_bash_file`
	if [ \( -z "$HUNTER_HOME" \) -a \( `grep '$HUNTER_HOME' $HOME/$BASH_FILE | wc -l` -eq 0 \) ]; then
		export HUNTER_HOME=$PATH_TO_INSTALLATION
		cat <<EOT >> $HOME/$BASH_FILE

# Definindo ENV_VAR \$HUNTER_HOME
[[ -z "\$HUNTER_HOME" ]] && export HUNTER_HOME=\$HOME/$DIRNAME_INSTALLATION
source \$HUNTER_HOME/lib/autocomplete.sh
# Fim da definição da ENV_VAR \$HUNTER_HOME

EOT

		echo ""
		echo 'Para utilizar o hunter inicie uma nova sessão no terminal ou execute o comando a seguir:';
		echo "    \$ export HUNTER_HOME=$PATH_TO_INSTALLATION && source \$HUNTER_HOME/lib/autocomplete.sh"
		echo ""
	fi
	
	echo 'Instalação concluída!!! \o/';
	echo ""

}

uninstallation(){

	export HUNTER_HOME=""
	BASH_FILE=`get_bash_file`
	sed -i"" "/\\\$HUNTER_HOME/d" "$HOME/$BASH_FILE";

	if [[ -f /usr/local/bin/hunter ]]; then
		echo 'Removendo binário... ';
		sudo rm -f /usr/local/bin/hunter
	fi

	if [ -d "$PATH_TO_INSTALLATION" ]; then
		echo 'Removendo suite... ';
		rm -rf $PATH_TO_INSTALLATION;
	fi

	echo "Desinstalação finalizada!!! :'(";
	echo ""
}


case $1 in
	-r) 
		uninstallation $@
	;;
	*)
		installation
	;;
esac