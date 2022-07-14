#Safe cert List
#This list of keys will be ignored in the compliance check if found
safe_cert="/etc/1.key /etc/2.key"
#All certs in "/etc"
certs=$(find /etc -type f -name '*.key')
output=""
flag=""

#if certs exist in the path
if [ $(echo "$certs"|wc -l) -gt 0 ]
then 
    #for each cert see if they are in the safe_cert list
    for i in $certs; do
        for j in $safe_cert; do
            if [ X"$i" = X"$j" ]; then
                flag="MATCH"          
            fi  
        done
        if [ "$flag" != "MATCH" ]; then
           output="${output}${i} "
        fi   
        flag=0
    done
    if [ "$output" != "" ]; then
        echo "Found: $output";
        exit 1
    fi    
 else
    echo "Not Found";
 fi   
