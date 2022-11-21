#!/bin/bash

echo;
for dir in `ls -d node*`;
do
    echo $dir "uptime:" | tr -d '\n';
    cat $dir/image/uptime | cut -d " " -f 1-7; echo; done > uptime.txt;
    cat uptime.txt; echo "====="; echo;
	rm uptime.txt;	
echo "last 10 nodes outages: "; echo
grep -i 'node is ' admin-log.sorted | tail | cut -d " " -f 1,2,3,8-10 | cut -c 3-21,29- | column -t | tr ',' ' ' | tr "'" ' ' | tr '.' ' ' > nice_cut
awk '{print $1"  "$2"  "$3"  "$4" "$5" "$6}' nice_cut
rm nice_cut
echo;
echo "=====";
echo;



echo "Checking JVM logs for known issues... "; echo
FILE=jvmallnodes.sorted
if [ -f "$FILE" ]; then
        if cat jvmallnodes.sorted | grep -q 'Pool is at maximum capacity'; then
        echo 'Pool is at maximum capacity: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Pool is at maximum capacity' | wc -l; echo
        fi

        if cat jvmallnodes.sorted | grep -q 'Rejecting since backlog'; then
        echo 'Rejecting since backlog: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Rejecting since backlog' | wc -l; echo
        fi

        if cat jvmallnodes.sorted | grep -q 'Unable to acquire request semaphore'; then
        echo 'Unable to acquire request semaphore: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Unable to acquire request semaphore' | wc -l; echo
        fi

        if cat jvmallnodes.sorted | grep -q 'Database connections exhausted'; then
        echo 'Database connections exhausted: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Database connections exhausted' | wc -l; echo
        fi

        if cat jvmallnodes.sorted | grep -q 'Shutting down due to uncaught exception'; then
        echo 'Shutting down due to uncaught exception: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Shutting down due to uncaught exception' | wc -l; echo
        fi

        if cat jvmallnodes.sorted | grep -q 'Unable to reply from hcpfsreaddirreceiver'; then
        echo 'Unable to reply from hcpfsreaddirreceiver: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Unable to reply from hcpfsreaddirreceiver' | wc -l; echo
        fi

        if cat jvmallnodes.sorted | grep -q 'held read lock'; then
        echo 'held read lock: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'held read lock' | wc -l; echo
        fi

        if cat jvmallnodes.sorted | grep -q 'Exceeded max connection'; then
        echo 'Exceeded max connection: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Exceeded max connection' | wc -l; echo
        fi

        if cat jvmallnodes.sorted | grep -q 'Caught exception when executing drainable thread: Namespace doHead'; then
        echo 'Caught exception when executing drainable thread: Namespace doHead: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'aught exception when executing drainable thread: Namespace doHead' | wc -l; echo
        fi

        if cat jvmallnodes.sorted | grep -q 'server.RISJVMInstance.immediateShutdown'; then
        echo 'server.RISJVMInstance.immediateShutdown: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'server.RISJVMInstance.immediateShutdown' | wc -l; echo
        fi

        if cat jvmallnodes.sorted | grep -q 'Shutting down with error code'; then
        echo 'Shutting down with error code: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Shutting down with error code' | wc -l; echo
        fi

        if cat jvmallnodes.sorted | grep -q 'java.lang.OutOfMemoryError'; then
        echo 'java.lang.OutOfMemoryError: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'java.lang.OutOfMemoryError' | wc -l; echo
        fi

        if cat jvmallnodes.sorted | grep -q 'new high water mark for work queue'; then
        echo 'new high water mark for work queue: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'new high water mark for work queue' | wc -l; echo
        fi

        if cat jvmallnodes.sorted | grep -q 'java.lang.NullPointerException'; then
        echo 'java.lang.NullPointerException: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'java.lang.NullPointerException' | wc -l; echo
        fi

        if cat jvmallnodes.sorted | grep -q 'Proxy crashed or shut down'; then
        echo 'Proxy crashed or shut down: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Proxy crashed or shut down' | wc -l; echo
        fi
else
        echo "$FILE does not exist. Please run 'getalljvmallnodes' script first"
fi

echo

