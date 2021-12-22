#!/bin/bash

###################################################################################################


# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

COLOR_LIGHT_GREEN="1;32"
COLOR_LIGHT_BLUE="1;34"
COLOR_LIGHT_RED="1;31"
COLOR_YELLOW="1;33"

echo_color(){
	echo -e -n "\033[0${1}m"$2"\033[00m"
}

change_color(){
	echo -e -n "\033[0${1}m"
}

reset_color(){
	echo -e -n "\033[00m"
}

echo_success(){
	echo_color $COLOR_LIGHT_GREEN "[SUCCESS] " && echo "$1"
}

echo_warning(){
	echo_color $COLOR_YELLOW "[WARNING] " && echo "$1"
}

echo_info(){
	echo_color $COLOR_LIGHT_BLUE "[INFO] " && echo "   $1"
}

echo_error(){
	echo_color $COLOR_LIGHT_RED "[ERROR] " && echo "  $1"
}


###################################################################################################