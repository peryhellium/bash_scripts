for i in namespacelist.txt
do
echo;echo "==================";echo "NAMESPACES SUMMARY";echo "==================";echo;
echo "Number of namespaces: " | tr -d '\n' ; grep -c namespace.tenant namespace-list.txt;
echo "Number of cloud optimized: " | tr -d '\n'; grep -c "'cloudOptimized' : True" namespace-list.txt;
echo "Number of replication enabled: " | tr -d '\n'; grep -c "'replicationEnabled' : True" namespace-list.txt;
echo "Number of indexing enabled: " | tr -d '\n'; grep -c "'indexingEnabled' : True" namespace-list.txt;
echo "Number of versioning Enabled: " | tr -d '\n'; grep -c "'versioningEnabled' : True" namespace-list.txt;
echo "Number of DPL1: " | tr -d '\n'; grep -c "'dpl' : '1'" namespace-list.txt;
echo "Number of DPL2: " | tr -d '\n'; grep -c "'dpl' : '2'" namespace-list.txt;
echo;echo "Service Planes used: ";echo; awk '{if ($1 ~ "servicePlanEffective") print " - ", $3}' namespace-list.txt | sort | uniq -c;
echo;echo "Number of tenants: " | tr -d '\n'; grep -wc name tenant-list.txt;
grep -w name tenant-list.txt > name_tenant;
echo;echo "Tenants list: ";echo; awk '{if ($1 ~ "name") print " - ", $3}' name_tenant | sort | uniq -c;
rm  name_tenant;
echo;echo;echo "==================";echo "LIST OF NAMESPACES";echo "==================";echo;echo;
grep namespace.tenant namespace-list.txt -B27 -A23 | egrep -vw 'httpSSOEnabled|searchEnabled|creationTimeMillis|customMetadataFullTextIndexingEnabled|customMetadataIndexingEnabled|customMetadataIndexingExcludeList|customMetadataParsingEnabled|description|dynamicDpl|enterpriseMode|hardQuota|hashScheme|indexingDefault|isAuthoritative|isCifsEnabled|isHidden|isHttpEnabled|isHttpsEnabled|isNfsEnabled|isS3Enabled|isSmtpEnabled|isWebdavEnabled|lowerName|minimumRetentionAfterInitialUnspecified|name|owner|parentUUID|permissionMask|permissionMaskString|readFromReplica|replicationCollisionAction|replicationCollisionDispositionDays|replicationCollisionDispositionEnabled|retentionDefault|retentionDispositionEnabled|servicePlan|serviceRemoteSystemRequests|shreddingDefault|softQuota|state|tags|unbalancedMode|version' | column -t;echo;done > namespaces_overview.txt;sed -i -e 's/,//g' namespaces_overview.txt; sed -i -e "s/'//g" namespaces_overview.txt; sed 's/--/= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = /g' namespaces_overview.txt | less
