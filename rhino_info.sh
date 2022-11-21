#!/bin/bash
if [ -d "001/image/" ];
then
 echo; echo "SYSTEM INFORMATION: ";
    echo;
    cat 001/image/config/cluster.cfg | grep -w 'software_version'; 
    cat 001/image/config/cluster.cfg | grep 'serial_number'; 
    cat 001/image/config/cluster.cfg | grep 'clname'; 
    cat 001/image/config/cluster.cfg | grep 'dns_servers';
    cat 001/image/config/cluster.cfg | grep 'timeserver'; 
    echo; echo "======"; echo;
 echo "ALERTS LIST: ";
    echo;
    cat 001/image/alerts-list; echo;
    echo "======"; echo;
 echo "CLUSTER STATUS: ";
    echo;
    cat 001/image/cluster-status.txt; echo;
    echo "======";echo;

echo "Enclosure List: ";
	echo;
	cat 001/image/enclosureman-list | egrep 'enclosureId|state[1-2]'; echo;
echo "======"; echo

 for dir in `ls -d 00*`;
  do
    echo;
    echo $dir "UPTIME: ";
    cat $dir/image/uptime; echo; echo;
    done;
elif [ ! -d "/001/image/config/cluster.cfg" ]; then
	echo; echo "SM1 not found. Checking SM2...";
	echo; echo "SYSTEM INFORMATION: ";
		echo;
		cat 002/image/config/cluster.cfg | grep -w 'software_version'; 
		cat 002/image/config/cluster.cfg | grep 'serial_number'; 
		cat 002/image/config/cluster.cfg | grep 'clname'; 
		cat 002/image/config/cluster.cfg | grep 'dns_servers'; 
		cat 002/image/config/cluster.cfg | grep 'timeserver'; 
		echo; echo "======"; echo;
	echo "ALERTS LIST: ";
		echo;
		cat 002/image/alerts-list; echo;
		echo "======"; echo;
	echo "CLUSTER STATUS: ";
		echo;
		cat 002/image/cluster-status.txt; echo;
		echo "======"; echo
	echo "Enclosure List: ";
        echo;
        cat 002/image/enclosureman-list | egrep 'enclosureId|state[1-2]'; echo;
	echo "======"; echo
	for dir in `ls -d 00*`;
	do
		echo;
		echo $dir "UPTIME: ";
		cat $dir/image/uptime; echo; echo;
		done;
else
 echo "no SM1 or SM2. Are You in the correct directory?";
fi



#made by Michal Glupczyk. Feel free to use and share. 
