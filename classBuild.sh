#!/bin/bash

if [ $# != 2 ]; then
    echo "Usage: sh classBuild.sh <account file> <group name>"
    exit
fi

file=$1
group=$2

# Step 1. Create Group
sudo addgroup $group
echo "Group [$group] has been created."

# Step 2. Create group directory at /home/[Group Name]
if [ ! -d /home/$group ]; then
    sudo mkdir /home/$group
    echo "Directory [/home/$group] has been created." 
fi

# Step 3. Create user per line as format [name,password]
while read -r line
do
    name=$(echo $line | cut -d',' -f1)
    password=$(echo $line | cut -d',' -f2)

    # Check user 
    if [ `id -u $name > /dev/null 2>&1; echo $?` ]; then
        sudo useradd -m -d /home/$group/$name -s /bin/bash $name
	echo $name:$password | sudo chpasswd
        echo "User [$name] has been created."
    else
        echo "User [$name] already exists!"
    fi
done < $file

echo ">> FIN <<"
