#!/bin/bash

set -o errexit

THIS_WIKI_DIR=$(dirname $(readlink -f $0))
TMP_CONFIG="/tmp/$(basename $THIS_WIKI_DIR).gititconfig"
WIKI_PUBLIC="false";

usage() {
cat <<USAGE

Usage:
    bash $0 [OPTIONS]

Description:
    Starts this projects wiki http server

OPTIONS:
    -P, --public
        Start wiki-server in public mode. Default is local-host only
    -p, --port
        Run wiki-server at port. Default port is read from file "port.conf"
        in same directory if it exists.
    -c, --config-file
        Use the following config file. Overloads any port arguments
    -h, --help
        This help

ENV VARS:
    Env-vars are used to set defaults. I.e. they can be used instead of
    arguments. If both are given, env-vars are weaker.

    PORT
        Set default port
    CONFIG_FILE
        Set default config-file

USAGE
}

#Load/assign defaults
if [ -f ${THIS_WIKI_DIR}/port.conf ]; then
	PORT=$(cat ${THIS_WIKI_DIR}/port.conf | head -n1)
fi
if [ -f ${THIS_WIKI_DIR}/../wiki_port.conf ]; then
	PORT=$(cat ${THIS_WIKI_DIR}/../wiki_port.conf | head -n1)
fi
PORT=${PORT-"3366"}

# Setup getopt.
long_opts="public,port:,config-file:,help"
getopt_cmd=$(getopt -o hp:Pc: --long "$long_opts" \
	-n $(basename $0) -- "$@") || {
		echo -e "\nERROR: Wrong options\nUse -h or --help for help";
		exit 1;
}
eval set -- "$getopt_cmd"

while true; do
    case "$1" in
        -P|--public) WIKI_PUBLIC="true";;
        -p|--port) PORT="$2"; shift;;
        -c|--config-file) CONFIG_FILE="$2"; shift;;
        -h|--help) usage; exit 0;;
        --) shift; break;;
    esac
    shift
done
if [ $# -gt 0 ]; then
    echo -e "\nERROR: Extra inputs. No arguments acceded, only options.\n"
    usage
    exit 1
fi

cat ${THIS_WIKI_DIR}/wiki.conf  | sed -Ee '/^port:/s/.*/port: '$PORT'/' > \
	$TMP_CONFIG

CONFIG_FILE=${CONFIG_FILE-"$TMP_CONFIG"}

if [ -f ~/.cabal/bin/gitit ]; then
	echo "Will start with local-build gitit binary... (preferred)"
	GITIT_BIN=~/.cabal/bin/gitit
else
	echo "Will start with system installed gitit binary..."
	GITIT_BIN=$(which gitit)
fi

if [ "X${GITIT_BIN}" == "X" ]; then
	echo -n "ERROR: Can't start. No gitit found, either Cabal-built nor " 1>&2
	echo "system installed." 1>&2
	exit 1
fi

if [ "X$(which screen 2>/dev/null)" == "X" ]; then
	echo "Error: screen needed to run service. Please install..."
	exit 1
fi

pushd ${THIS_WIKI_DIR} >/dev/null
	#get config port:
	CPORT=$(grep -e'^port:[[:space:]]' ${CONFIG_FILE} | cut -f2 -d" ")
	SESSION_NAME="wiki-$(basename $(cd ../; pwd))"
	echo
  if [ "X${WIKI_PUBLIC}" == "Xtrue" ]; then
		echo "Gitit starting PULIC webserver at $(hostname):${CPORT} in screen"
		SESSION_NAME="${SESSION_NAME}-public"
		screen -dmS "${SESSION_NAME}" ${GITIT_BIN} -f ${CONFIG_FILE}
	else
		echo "Gitit starting locally restricted webserver at http://127.0.0.1:${CPORT} in screen"
		screen -dmS "${SESSION_NAME}" ${GITIT_BIN} -f ${CONFIG_FILE} -l 127.0.0.1
	fi
	echo "To enter screen session running the server (for debug):"
	echo "  screen -rd \"${SESSION_NAME}\""
	echo
	if	[ "X$(uname -a | grep -i CYGWIN)" != "X" ]; then
		cygstart http://localhost:${CPORT}
	else
		xdg-open http://localhost:${CPORT}
	fi
popd >/dev/null

echo "Opened start-page for you in local browser..."
