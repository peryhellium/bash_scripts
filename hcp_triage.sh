#!/bin/bash
echo; echo "UPTIME"; cat node*/image/uptime; echo;
echo; echo 'Pool is at maximum capacity: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Pool is at maximum capacity' | wc -l;  echo "======";echo;
echo 'Rejecting since backlog: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Rejecting since backlog' | wc -l;  echo "======";echo;
echo 'Unable to acquire request semaphore: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Unable to acquire request semaphore' | wc -l;  echo "======";echo;
echo 'Database connections exhausted: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Database connections exhausted' | wc -l;  echo "======";echo;
echo 'Shutting down due to uncaught exception: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Shutting down due to uncaught exception' | wc -l;  echo "======";echo;
echo 'Unable to reply from hcpfsreaddirreceiver: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Unable to reply from hcpfsreaddirreceiver' | wc -l;  echo "======";echo;
echo 'held read lock: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'held read lock' | wc -l;  echo "======";echo;
echo 'Exceeded max connection: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Exceeded max connection' | wc -l;  echo "======";echo;
echo 'Caught exception when executing drainable thread: Namespace doHead: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Caught exception when executing drainable thread: Namespace doHead' | wc -l;  echo "======";echo;
echo 'server.RISJVMInstance.immediateShutdown: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'server.RISJVMInstance.immediateShutdown' | wc -l;  echo "======";echo;
echo 'Shutting down with error code: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Shutting down with error code' | wc -l;  echo "======";echo;
echo 'java.lang.OutOfMemoryError: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'java.lang.OutOfMemoryError' | wc -l;  echo "======";echo;
echo 'new high water mark for work queue: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'new high water mark for work queue' | wc -l;  echo "======";echo;
echo 'NullPointerException: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'java.lang.NullPointerException' | wc -l;  echo "======";echo;
echo 'Proxy crashed or shut down: ' | tr -d '\n' ; cat jvmallnodes.sorted | grep -w 'Proxy crashed or shut down' | wc -l;  echo "======";echo;
