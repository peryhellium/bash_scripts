#!/bin/bash

#script for checking recent drive issues on HCP (both G10 and G11)
#made by Michal Glupczyk, feel free to use and copy anywhere. 

#changelog:
# - checking if in the right directory (/ci/caseNumber/HCPlogs)
# - better handling for cases where none drive failures has been discovered
# - added Firwamre state when drive is degraded in G10
# - added rebuild progress in G10



#checking if you are on the right directory:
if [[ ! -f hcpinfo.out ]]
then
	echo; echo "Please execute the script from the HCP logs main directory"; echo
	exit
fi

echo
echo "do you want to run the script automatically or to choose the node manually?"; echo
echo "[a]utomatically, [m]anually, [c]ancel"
echo
read choice


#automatic run
if [[ $choice = "a" || $choice = "automatically" ]];
then
        echo; echo "Performing automatic search...";
        if grep -q D51B hcpinfo.out
        then
        	echo; echo "System: HCP G10. Looking for a recent drives issues..."; echo
        	if ! grep -q mounted admin-log.sorted
		then
			echo; echo "No drive errors found. Thank You for choosing our company"; echo
			exit
		fi	
		echo "latest messages:"; echo
        	grep mount admin-log.sorted | tr -d "'"  | awk -F 'None, None' '{ print $1 }' | awk '{for(z=4;z<=7;z++)$z="";$0=$0;$1=$1}1' | cut -c2- | tail -n 9; echo
        	lastline=$(grep -i mount admin-log.sorted | awk '{print $3}'  |  tail -n 1 | sed 's/.$//')
        	echo "checking node"$lastline "drives issues..."; echo
        	grep HDD node$lastline/image/ipmi_sel.log | grep -vi 'Drive Present'| tail; echo
                if grep -q 'Firmware state: Failed' node$lastline/image/megacli_info
                then
                        failedDrive=$(grep 'Firmware state: Failed' -B20  node$lastline/image/megacli_info | grep Slot)
                        echo "Failed drive found in "$failedDrive; echo
                        egrep 'Firmware state|Slot' node$lastline/image/megacli_info; echo
                        grep -i "Device Present" -A 8 node$lastline/image/megacli_info; echo
                        grep -B7 'Firmware state: Failed' node15/image/megacli_info | egrep 'Raw|Firmware'; echo
                        echo "Part number: 1HY7ZCZ0007 / 4TB 7.2K RPM SAS3 12Gbps LFF Kit, MakaraBP"; echo
                        echo "confirm in Asset Hierarchy or Spares site"; echo
                        echo "KB article: https://knowledge.hitachivantara.com/Knowledge/Storage/Content_Platform/How_to_Determine_HCP_G10_with_Local_Storage_Failed_Disk_Part_Number"; echo
                elif grep -q 'Firmware state: Rebuild' node$lastline/image/megacli_info
                then
			echo; echo "Current drives states in node" $lastline; echo
			egrep 'Firmware state|Slot' node$lastline/image/megacli_info; echo
			echo; echo "Current rebuild progress: "; echo; egrep 'Time|Rebuild progress' node$lastline/image/megacli_events.log | head -n 6; echo
                        echo "Rebuild in progress. Ask the customer to monitor it and check the status in GUI. If the drive is successfully rebuilt nad online, no action needs to be taken."; echo
                else
                        echo "no failed drives found on the node" $lastline; echo
                fi

        elif grep -q DS220 hcpinfo.out
        then
        	echo; echo "System: HCP G11. Looking for a recent drives issues... "; echo
		if ! grep -q mounted admin-log.sorted
                then
                        echo "No drive errors found. Thank You for choosing our company"; echo
                        exit
		fi

		echo "latest messages:"; echo
        	grep mount admin-log.sorted | tr -d "'"  | awk -F 'None, None' '{ print $1 }' | awk '{for(z=4;z<=7;z++)$z="";$0=$0;$1=$1}1' | cut -c2- |  tail -n 10; echo
		lastline=$(grep -i mount admin-log.sorted | awk '{print $3}'  |  tail -n 1 | sed 's/.$//')
        	echo "checking node"$lastline "drives issues..."; echo
        	grep HDD node$lastline/image/ipmi_sel.log | grep -vi 'Drive Present'| tail; echo
		if grep -q 'DRIVE Failed' node$lastline/image/storcli_info
		then
			failedDrive=$(grep 'DRIVE Failed' node$lastline/image/storcli_info | head -n 1)
			echo "Failed drive found: "$failedDrive
			echo -n "Topology: "; grep 'Failed' node$lastline/image/storcli_info | tail -n 1 | awk '{print $5, $6, $7, $8}'; echo
			echo "Check for part number in Asset Hierarchy or Spares site"; echo
                	echo "KB article: https://knowledge.hitachivantara.com/Knowledge/Storage/Content_Platform/How_to_Determine_HCP_G11_with_Local_Storage_Failed_Disk_and_Part_Number"; echo
		else
			echo "no failed drives found on the node" $lastline; echo
		fi

        else
        echo "This HCP is neither G10 or G11. Looks like VM system"; echo
        fi

#manual run
elif [[ $choice = "m" || $choice = "manually" ]];
then
	echo; echo "Please type node number from available nodes: "; echo
	ls | grep node[0-9] | sed -e 's/node//g' | paste -s -d ' ' 
	
	echo;
	read nodeNumber
	if [[ ! -f node$nodeNumber/image/ipmi_sel.log ]] 
	then	
		echo; echo "node not found! Please chose from the list of available nodes";echo
		exit
	fi
	
        if grep -q D51B hcpinfo.out
        then
        	echo; echo "System: HCP G10. Looking for a recent drives issues... "; echo
        	echo "latest messages:"; echo
        	grep mount admin-log.sorted | tr -d "'"  | awk -F 'None, None' '{ print $1 }' | awk '{for(z=4;z<=7;z++)$z="";$0=$0;$1=$1}1' | cut -c2- | tail -n 9; echo
                echo "checking node"$nodeNumber "drives issues..."; echo
        	grep HDD node$nodeNumber/image/ipmi_sel.log | grep -vi 'Drive Present'| tail; echo
                if grep -q 'Firmware state: Failed' node$nodeNumber/image/megacli_info
                then
                        failedDrive=$(grep 'Firmware state: Failed' -B20  node$nodeNumber/image/megacli_info | grep Slot)
                        echo "Failed drive found in "$failedDrive; echo
                        egrep 'Firmware state|Slot' node$nodeNumber/image/megacli_info; echo
                        grep -i "Device Present" -A 8 node$nodeNumber/image/megacli_info; echo
                        grep -B7 'Firmware state: Failed' node15/image/megacli_info | egrep 'Raw|Firmware'; echo
                        echo "Part number: 1HY7ZCZ0007 / 4TB 7.2K RPM SAS3 12Gbps LFF Kit, MakaraBP"; echo
                        echo "confirm in Asset Hierarchy or Spares site"; echo
                        echo "KB article: https://knowledge.hitachivantara.com/Knowledge/Storage/Content_Platform/How_to_Determine_HCP_G10_with_Local_Storage_Failed_Disk_Part_Number"; echo
                elif grep -q 'Firmware state: Rebuild' node$nodeNumber/image/megacli_info
                then
                        echo; echo "Current drives states in node" $nodeNumber; echo
			egrep 'Firmware state|Slot' node$nodeNumber/image/megacli_info; echo
                        echo; echo "Current rebuild progress: "; echo; egrep 'Time|Rebuild progress' node$nodeNumber/image/megacli_events.log | head -n 6; echo
			echo "Rebuild in progress. Ask the customer to monitor it and check the status in GUI. If the drive is successfully rebuilt nad online, no action needs to be taken."; echo
                else
                        echo "no failed drives found on the node" $nodeNumber; echo
                fi

        elif grep -q DS220 hcpinfo.out
        then
        	echo; echo "System: HCP G11. Looking for a recent drives issues... "; echo
        	echo "latest messages:"; echo
		grep mount admin-log.sorted | tr -d "'"  | awk -F 'None, None' '{ print $1 }' | awk '{for(z=4;z<=7;z++)$z="";$0=$0;$1=$1}1' | cut -c2- |  tail -n 10
		lastline=$(grep -i mount admin-log.sorted | awk '{print $3}'  |  tail -n 1 | sed 's/.$//')
                echo; echo "checking node"$nodeNumber "drives issues..."; echo
                grep HDD node$nodeNumber/image/ipmi_sel.log | grep -vi 'Drive Present'| tail; echo
                if grep -q 'DRIVE Failed' node$nodeNumber/image/storcli_info
                then
                        failedDrive=$(grep 'DRIVE Failed' node$nodeNumber/image/storcli_info | head -n 1)
                        echo "Failed drive found: "$failedDrive
                        echo -n "Topology: "; grep 'Failed' node$nodeNumber/image/storcli_info | tail -n 1 | awk '{print $5, $6, $7, $8}'; echo
                        echo "Check for part number in Asset Hierarchy or Spares site"; echo
                        echo "KB article: https://knowledge.hitachivantara.com/Knowledge/Storage/Content_Platform/How_to_Determine_HCP_G11_with_Local_Storage_Failed_Disk_and_Part_Number"; echo
                else
                        echo "no failed drives found on the node" $nodeNumber; echo
                fi


	
        else
        echo "This HCP is neither G10 or G11. Looks like VM system"; echo
        fi

#cancel
elif [[ $choice = "c" || $choice = "cancel" ]];
then
        echo; echo "Goodbye!"; echo
	exit

#input not valid
else
        echo; echo "Sorry, input not valid. Please choose from [a]utomatically, [m]anually, [c]ancel"; echo

fi
