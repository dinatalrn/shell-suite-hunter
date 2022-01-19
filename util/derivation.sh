#!/bin/bash

SCRIPTDIR=`cd "$(dirname "$0")" && pwd`
SCRIPTDIR=`echo "$SCRIPTDIR" | sed -E 's#/[^/]+$##'`

help_derivation(){
	echo ""
	echo "O nome da derivação deve ser composta de no mínimo 2 caracteres, "
	echo "  dentre eles são permitidos apenas os seguintes caracteres: "
	echo ""
	echo "   - Entre 'a' e 'z'"
	echo "   - Entre 0 e 9"
	echo "   - E hífen (-)"
	echo ""
	echo "Porém o hífen (-) não poder ficar no início ou fim do novo nome."
	echo ""
}

if [[ $# -eq 1 ]]; then
	if [[ `grep -E '^[a-z0-9][a-z0-9\-]*[a-z0-9]$' <<< "$1" | wc -l` -eq 1 ]]; then
		echo ""
		if [[ "$1" = "hunter" ]]; then
			echo "A derivação não pode ser nomeada como 'hunter'! "
			echo ""
			exit 1
		fi
		read -n 1 -p "Deseja realmente criar uma derivação do hunter chamada '$1'? [Yn] " CHOICE
		[ ! -z "$CHOICE" ] && echo ""
		echo ""
		case "$CHOICE" in
			""|[Yy] )
				echo -n "Removendo controle de versão... "
				[ -d $SCRIPTDIR/.git ] && rm -rf $SCRIPTDIR/.git/
				echo "Pronto!"

				echo -n "Renomeando referências do 'hunter' para '$1'... "
				grep -R hunter $SCRIPTDIR | awk -F : '{print $1}' | grep -E '(/hunter|\.sh)$' | sort -u | grep -Ev 'derivation.sh$' | xargs sed -i'' 's/hunter/'$1'/g'
				echo "Pronto!"

				ENV_VAR_DERIVATION=`awk '{print toupper($0)}' <<< "${1}_HUNTER_HOME"`
				echo -n "Renomeando referências da ENV_VAR 'HUNTER_HOME' para '$ENV_VAR_DERIVATION'... "
				grep -R "HUNTER_HOME" $SCRIPTDIR | awk -F : '{print $1}' | grep -E '(/hunter|\.sh)$' | sort -u | grep -Ev 'derivation.sh$' | xargs sed -i'' 's/HUNTER_HOME/'$ENV_VAR_DERIVATION'/g'
				echo "Pronto!"

				echo -n "Criando o '$1' com base no 'hunter'... "
				[ -f $SCRIPTDIR/hunter ] && mv $SCRIPTDIR/hunter $SCRIPTDIR/$1
				echo "Pronto!"

				echo -n "Removendo este script de derivação... "
				[ -f $SCRIPTDIR/util/derivation.sh ] && rm -f $SCRIPTDIR/util/derivation.sh
				echo "Pronto!"
				;;
			* )
				echo "A operação de derivação do hunter foi cancelada! \o/ Faz um fork... ;P"
				echo ""
				echo "https://github.com/dinatalrn/shell-suite-hunter"
				;;
		esac
		echo ""
	else
		help_derivation
	fi
else
	echo ""
	echo "Este comando deve ser executado assim:"
	echo ""
	echo "  \$ $0 <nome-da-derivacao>"
	help_derivation
fi