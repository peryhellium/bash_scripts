#!/bin/bash

echo
echo "Checking objects in a Policy State on each node..."
echo

if ! grep -q None node*/image/policy-state.dump; then
	echo "nothing was found"; echo;exit
else echo; echo "Total number of objects found: " | tr -d '\n'; cat node*/image/policy-state.dump | grep -w "None" | wc -l; echo;
	echo "Total number of objects found: " | tr -d '\n' > total_number; cat node*/image/policy-state.dump | grep -w "None" | wc -l >> total_number; echo >> total_number;
fi

for dir in `ls -d node*`;
do
    	if cat $dir/image/policy-state.dump | grep -q "None" ; then
		#list objects
    		echo; echo "Policy state objects " | tr -d '\n' ; echo "($dir):" ; echo 
		printf '     TIME     EF_NAME     VERSION_ID     NAMESPACE_UUID     POLICY_TYPE   STATUS'  > header;
		awk '{print $1"/"$2}' $dir/image/policy-state.dump | tail -n +2 | cut  -d "." -f1 > loc1;
		awk '{print $3, $4, $5, $6, $7}' $dir/image/policy-state.dump | tail -n +2 > loc2;
		sed -i 's/[(,]//g' loc1	loc2	
		sed -i '1i\\' loc1 loc2
		paste loc1 loc2 > col1	
		sed -i -e "s/'//g" col1
		paste header col1 | column -o ' | ' -t > col3
		cat col3 

		#namespace info
		echo; echo; echo "objects found in below namespace(s): ";echo		
		awk '{print $5}' $dir/image/policy-state.dump > ns1
		grep -f ns1 $dir/image/namespace-list.txt -B27 | egrep 'namespace.tenant|uuid' > ns2;
		sed -i -e "s/'//g" ns2
		sed -i -e 's/,//g' ns2
		cat ns2 | column -t
		echo; echo
	
	fi
done > invalid_objects.txt;
rm col* loc* ns* header

for dir in `ls -d node*`;
do
    if 	cat $dir/image/policy-state.dump | grep -q "None" ; then
	cat $dir/image/policy-state.dump
    fi
done > policy_state;
    
	
	awk '{if ($9 ~ "None") print $0}' policy_state > mypolice
	awk '{print $3}' mypolice > object_and_dir
	sed 's/\/.*\///' object_and_dir > object_only
	cat object_only | tr -d "'," > cleaned
	


if cat mypolice | grep -q ' 2,'; then		
        echo; echo '- '  | tr -d '\n' ; cat mypolice | grep -w ' 2,' | wc -l | tr -d '\n'; echo " objects in policy state 2 = INVALID (aka IRREPARABLE)"
fi

if cat mypolice | grep -q ' 3,'; then
        echo; echo '- '  | tr -d '\n' ; cat mypolice | grep -w ' 3,' | wc -l | tr -d '\n'; echo " objects in policy state 3 = RECONCILED (aka ACKNOWLEDGED)"
fi

if cat mypolice | grep -q ' 4,'; then
        echo; echo '- '  | tr -d '\n' ; cat mypolice | grep -w ' 4,' | wc -l | tr -d '\n'; echo " objects in policy state 4 = UNAVAILABLE"
fi

if cat mypolice | grep -q ' 8,'; then
        echo; echo '- '  | tr -d '\n' ; cat mypolice | grep -w ' 8,' | wc -l | tr -d '\n'; echo " objects in policy state 8 = UNREPLICATABLE_OPEN"
fi

if cat mypolice | grep -q ' 16,'; then
        echo; echo '- '  | tr -d '\n' ; cat mypolice | grep -w ' 16,' | wc -l | tr -d '\n'; echo " objects in policy state 16 = UNREPLICATABLE_IRREPARABLE"
fi

if cat mypolice | grep -q ' 18,'; then
        echo; echo '- '  | tr -d '\n' ; cat mypolice | grep -w ' 18,' | wc -l | tr -d '\n'; echo " objects in policy state 18 = INVALID + UNREPLICATABLE_IRREPARABLE (2 + 16)"
fi

if cat mypolice | grep -q ' 20,'; then
        echo; echo '- '  | tr -d '\n' ; cat mypolice | grep -w ' 20,' | wc -l | tr -d '\n'; echo " objects in policy state 20 = UNAVAILABLE + UNREPLICATABLE_IRREPARABLE (4 + 16)"
fi

if cat mypolice | grep -q ' 32,'; then
        echo; echo '- '  | tr -d '\n' ; cat mypolice | grep -w ' 32,' | wc -l | tr -d '\n'; echo " objects in policy state 32 = MISMATCHED_CUSTOM_METADATA"
fi

if cat mypolice | grep -q ' 34,'; then
        echo; echo '- '  | tr -d '\n' ; cat mypolice | grep -w ' 34,' | wc -l | tr -d '\n'; echo " objects in policy state 34 = INVALID + MISMATCHED_CUSTOM_METADATA (2 + 32)"
fi

if cat mypolice | grep -q ' 50,'; then
        echo; echo '- '  | tr -d '\n' ; cat mypolice | grep -w ' 50,' | wc -l | tr -d '\n'; echo " objects in policy state 50 = INVALID + UNREPLICATABLE_IRREPARABLE + MISMATCHED_CUSTOM_METADATA (2 + 16 + 32)"
fi

if cat mypolice | grep -q ' 52,'; then
        echo; echo '- '  | tr -d '\n' ; cat mypolice | grep -w ' 52,' | wc -l | tr -d '\n'; echo " 52 = UNAVAILABLE + UNREPLICATABLE_IRREPARABLE + MISMATCHED_CUSTOM_METADATA (4 + 16 + 32)"
fi

if cat mypolice | grep -q ' 64,'; then
        echo; echo '- '  | tr -d '\n' ; cat mypolice | grep -w ' 64,' | wc -l | tr -d '\n'; echo " objects in policy state 64 = UNREPLICATABLE_TRANSIENT. That should clear itself automatically."
fi

if cat mypolice | grep -q ' 84,'; then
        echo; echo '- '  | tr -d '\n' ; cat mypolice | grep -w ' 84,' | wc -l | tr -d '\n'; echo " objects in policy state 84 = UNAVAILABLE + UNREPLICATABLE_IRREPARABLE + UNREPLICATABLE_TRANSIENT (4 + 16 + 64). That should clear itself automatically."
fi
echo

cat invalid_objects.txt;


#checking in admin-logs. If You want to count objects, uncomment below lines
if [ -s cleaned ]; then
	#declare -i var=0
	mapfile -t array < cleaned
	echo "Searching invalid objects entries in admin logs..."
	echo
	for i in "${array[@]}"
	do
			#let "var++"
			#echo "object $var"
			#echo
			grep "$i" admin-log.sorted
			done > object_messages.txt
fi

echo; echo "last 5 entries: ";echo
tail -n 5 object_messages.txt

if [ -s object_messages.txt ]; then
        # The file is not-empty.
		echo;echo;echo "full output of the script saved in policy_state_info.txt file"
fi

cat total_number invalid_objects.txt object_messages.txt > policy_state_info.txt

rm mypolice policy_state object_and_dir object_only cleaned invalid_objects.txt object_messages.txt total_number

echo;echo

#done by Michal Glupczyk. Feel free to use and copy anywhere. 
