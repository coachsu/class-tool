#!/bin/bash

if [ $# != 5 ]; then
    echo "Usage: sh assignmentCollect.sh <name> <wildcard> <group dir> <destination dir> [YYYY-MM-DD]"
    exit
fi

name=$1
req=$2
groupdir=$3
destdir=$4
dead=$5

echo ">> START"
# Step 1. Create destination directory
if [ ! -d $destdir ]; then
    sudo mkdir $destdir
    sudo chown -R $USER:$USER $destdir
    echo "Directory [$destdir] has been created." 
fi

# Step 2. Collect assignment per student
echo ">> ASSIGNMENT REPORT FOR [$name]" > $destdir/log
echo ">> DEADLINE: $dead" | tee -a $destdir/log
echo ">> LAST UPDATE: " $(date +"%Y-%m-%d") >> $destdir/log
echo "" >> $destdir/log
count=0
submit=0
for student in "$groupdir"/*
do
    count=$(( count + 1 ))
    stdid=`basename $student`

    if [ `ls $student/$req > /dev/null 2>&1; echo $?` -eq 0 ]; then
        first=1
        for file in $student/$req
        do 
            name=`basename "$file"`
            date=`stat -c %y "$file" | cut -d' ' -f1`
            due=""
            if [ $(date -d "$date" "+%s") -gt $(date -d "$dead" "+%s") ]; then
                due="OVERDUE"
            fi
            
            sudo cp "$file" -p $destdir
            if [ $first -eq 1 ]; then
                printf "%-10s\t%-5s\t%-20s\t%s\t%s\n" "$stdid" "YES" "$name" "$date" ""$due | tee -a $destdir/log
                submit=$(( submit + 1 ))
                first=0
            else
                printf "%-10s\t%-5s\t%-20s\t%s\t%s\n" "-" "-" "$name" "$date" "$due" | tee -a $destdir/log
            fi
        done
    else
        echo "$stdid" | tee -a $destdir/log
    fi
done

echo "" | tee -a $destdir/log
echo ">> SUMMARY" | tee -a $destdir/log
echo "NO. OF STUDENTS: $count" | tee -a $destdir/log
echo "NO. OF SUBMIT: $submit" | tee -a $destdir/log
echo "RATIO OF SUBMIT: $(( submit * 100 / count ))%" | tee -a $destdir/log

echo "FIN <<"
