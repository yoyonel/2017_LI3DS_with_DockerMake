# urls: 
# - http://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'        # GREEN
BLUE='\033[0;34m'         # BLUE
CYAN='\033[0;36m'         # CYAN
NC='\033[0m' 			  # No Color
BOLD='\033[1m'			  # BOLD
GREENBOLD='\033[0;32m\033[1m'
ECHO_PREFIX="[${BOLD}$0${NC}] "

echo_c () {
	echo -e "${ECHO_PREFIX}${RED}$1${NC}"
}

echo_w () {
	echo -e "${ECHO_PREFIX}${YELLOW}$1${NC}"
}

echo_i () {
	echo -e "${ECHO_PREFIX}${CYAN}$1${NC}"
}

USE_TUPLES_LIST() {
	# url: http://stackoverflow.com/a/9713189
	# $1: list tuples ((value0, value1) (value0, value1) ...)
	# $2: echo bash instruction							($1: value0, $2: value1)
	# $3: sh command (using bash parameters (results))	($1: value0, $2: value1)
	TUPLES=$1
	CALLBACK_ECHO=$2
	CALLBACK_CMD=$3

	# on retire les espaces, retours lignes, tabM
	TUPLES=$(echo "$TUPLES" | sed 's/ //g' | tr -d '\n' | tr -d '\t')
	# echo "TUPLES: ${TUPLES}"

	IFS='()'
	for t in $TUPLES; do
		[ -n "$t" ] &&
		{
			IFS=','
			set -- $t
			[ -n "$1" ] &&
			eval $CALLBACK_ECHO
			eval $(eval echo '$CALLBACK_CMD')	# ok
		};
	done
}