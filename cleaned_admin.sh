#!/bin/bash

echo; echo "cleaning admin-logs... may take few minutes";echo;

awk -F None '{ print $1 }' admin-log.sorted > TMP1	#remove everything after the message

awk '{for(z=4;z<=7;z++)$z="";$0=$0;$1=$1}1' TMP1 > TMP2 #leave only columns 1-3 + message

cat TMP2 | tr -d "('," > TMP3

awk '{print $1, $2}' TMP3 | column -t > TMPtime

awk -F . '{ print $1 }' TMPtime > TMPtime1 

awk -F + '{ print $1 }' TMPtime1 > TMPtime2

awk '{print $3}' TMP3 | column -t > TMPnumber_node

paste TMPtime2 TMPnumber_node > TMPtime_and_nodes

awk '{$3 = "- " $3}1' TMPtime_and_nodes > TMPwith_dash

awk '{$5 = "- " $5}1' TMPwith_dash > TMPdouble_dash

awk '{for(z=1;z<=3;z++)$z="";$0=$0;$1=$1}1' TMP3 > TMPonly_test

paste TMPdouble_dash TMPonly_test > TMP4

awk 'NR>2 {print last} {last=$0}' TMP4 > TMPfinal 	#remove last line

cat TMPfinal | tr '\t' '  ' > cleaned_admin-logs.txt 	#last formatting

# optional: egrep -vi 'service|Location metrics' cleaned_admin-logs.txt > TMP5
# mv TMP5 cleaned_admin-logs.txt
# unconnect these lines if needed

rm TMP*

echo; echo "Done. Check cleaned_admin-logs.txt file";echo
