#!/bin/bash

if [ $# != 3 ]; then
    echo "Usage: sh asCollectBatch.sh <group dir> <assignment description file> <log dir>"
    exit
fi

group=$1
file=$2
log=$3

# Step 1. Create log directory at 
if [ ! -d $log ]; then
    sudo mkdir $log
    echo "Directory [$log] has been created." 
fi

# Step 2. Collect assignment per line as format [name,wildcard,deadline]
while read -r line
do
	start=`echo $line | cut -c1-1`
	if [ $start = '#' ]; then
		continue
	fi
    name=$(echo $line | cut -d',' -f1)
    wildcard=$(echo $line | cut -d',' -f2)
    deadline=$(echo $line | cut -d',' -f3)

    # collect assignment
    sudo sh assignmentCollect.sh $name $wildcard $group $name $deadline
	sudo cp $name/log $log/$name-$(date +"%Y%m%d").log
done < $file

echo ">> FIN <<"
