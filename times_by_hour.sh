#!/bin/bash
while true; do
    echo "Enter the filename:"
    read filename
    if [ "$filename" == "exit" ]; then
        echo "Exiting script..."
        break
    elif [ ! -f $filename ]; then
        echo "The file does not exist, please provide the correct filename or type 'exit' to quit"
    else
        echo  "calculating average response times in file" $filename, "which is `ls -lh $filename|awk '{print $5}'`... this may take a while"; echo
        # Get the average response time for all requests
        average_response_time=$(awk '{ sum += $12/1000 } END { print sum/NR }' $filename)
        # Get the data for each hour

                echo  "----------------------------------------------------------------------------------"
                echo  "     Date and Time      |   Response Time   |    Delta     |  Number of Requests    "
                echo  "----------------------------------------------------------------------------------"

        awk -v average_response_time="$average_response_time" '{
            hour=substr($4,2,15);
            sum_time[hour] += $12/1000;
            count[hour]++;
        }
        END {
             for (i in sum_time) {
                printf "%-15s  |   %10s   |   %-10s | %10s\n", i "(00-59)", sprintf("%.3f", sum_time[i]/count[i]) " seconds", sprintf("%+.3f", sum_time[i]/count[i] - average_response_time), count[i]

            }
        }' $filename | sort -n
        break;
    fi
done
echo
#created by Michal Glupczyk, 2023. Feel free to use and share.
