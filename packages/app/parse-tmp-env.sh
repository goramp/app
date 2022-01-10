#!/usr/bin/env bash
TMP_FILE=$1
DEST_ENV=$2

awk '{while(match($0,"[$]{[^}]*}")) {var=substr($0,RSTART+2,RLENGTH -3);gsub("[$]{"var"}",ENVIRON[var])}}1' < ${TMP_FILE} > ${DEST_ENV}

echo "COMPLETED PARSING OF ENVIRONMENT VARIABLES";
