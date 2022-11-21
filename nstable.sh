
#!/bin/bash
awk '{if ($1 ~ "namespace.tenant") print $3}' namespace-list.txt > awk1
awk '{if ($1 ~ "cloudOptimized") print $3}' namespace-list.txt > awk2
awk '{if ($1 ~ "replicationEnabled") print $3}' namespace-list.txt > awk3
awk '{if ($1 ~ "indexingEnabled") print $3}' namespace-list.txt > awk4
awk '{if ($1 ~ "versioningEnabled") print $3}' namespace-list.txt > awk5
awk '{if ($1 ~ "dpl") print $3}' namespace-list.txt > awk6
awk '{if ($1 ~ "servicePlanEffective") print $3}' namespace-list.txt > awk7
awk '{if ($1 ~ "uuid") print $3}' namespace-list.txt > awk8


paste awk1 awk2 awk3 awk4 awk5 awk6 awk7 awk8  > table1
sed -i '1i\\' table1
rm awk*
sed -i -e 's/,//g' table1
sed -i -e "s/'//g" table1
touch header
printf 'NAMESPACE.TENANT CLOUD-OPT? REPLICATION? INDEXING? VERSIONING? DPL SERVICE-PLAN UUID' > header

paste header table1 | column -o ' | ' -t > table2

sed -i 's/True/TRUE/g' table2
sed -i 's/False/false/g' table2

awk ' {print;} NR % 1 == 0 { print "--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---"; }' table2 > nstable

rm table1 table2
less nstable


#created by Michal Glupczyk. Feel free to use
