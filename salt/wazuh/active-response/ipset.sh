#!/bin/sh
# Expect: srcip
# Author: Ludovic Houdayer

ACTION=$1
USER=$2
IP=$3

LOCAL=`dirname $0`;
cd $LOCAL
cd ../
PWD=`pwd`
SET='blacklist'

# Logging the call
echo "`date` $0 $1 $2 $3 $4 $5" >> ${PWD}/../logs/active-responses.log


# IP Address must be provided
if [ "x${IP}" = "x" ]; then
   echo "$0: Missing argument <action> <user> (ip)"
   exit 1;
fi

if ! (ipset list ${SET} | grep -q Name)
then
    echo "$0: Missing ipset ${SET}"
    exit 1
fi


# Custom block (touching a file inside /ipblock/IP)
if [ "x${ACTION}" = "xadd" ]; then
    ipset add ${SET} ${IP} timeout 1800
elif [ "x${ACTION}" = "xdelete" ]; then
    ipset del ${SET} ${IP}
# Invalid action
else
   echo "$0: invalid action: ${ACTION}"
fi

exit 1;

