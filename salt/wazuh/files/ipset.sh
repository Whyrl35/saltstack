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

if ! (nft list set ip filter ${SET} | grep -q ipv4_addr)
then
    echo "$0: Missing IPv4 set ${SET}"
    exit 1
fi

if ! (nft list set ip6 filter ${SET} | grep -q ipv6_addr)
then
    echo "$0: Missing IPv6 set ${SET}"
    exit 1
fi

if ! ipv6calc --showinfo ${IP} 2>&1 | grep -q 'ipv'
then
    echo "${0}: ${IP} is not a valid IP"
    exit 1
else
    if ipv6calc --showinfo ${IP} 2>&1 | grep -q 'ipv4addr'
    then
	ip='ip'
    else
	ip='ip6'
    fi
fi

if [ "x${ACTION}" = "xadd" ]; then
    nft add element ${ip} filter ${SET} { ${IP} }
elif [ "x${ACTION}" = "xdelete" ]; then
    nft delete element ${ip} filter ${SET} { ${IP} }
else
   echo "$0: invalid action: ${ACTION}"
fi

exit 1;
