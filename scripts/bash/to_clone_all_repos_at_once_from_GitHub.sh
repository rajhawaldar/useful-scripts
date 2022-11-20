#!/bin/bash

# To clone all repos at once from GitHub.

# Step-1 (Only first time)
# Follow github cli documentation : https://github.com/cli/cli#installation

# Step-2 (Only first time)
# login with gh using the terminal: gh auth login 

# Replace orgname value with your orgname.
orgname=""

# You can change the value of limit as per your need. 
# Remember if you set limit=5 then 4 repositories will get clone.
limit=5

gh repo list $orgname --limit $limit |  while read -r repo _; do
    # To skip the repositories whic are already present in current directory.
    dirName=$(echo "$repo" | cut -d "/" -f 2)
    if [[ ! -d $dirName ]];
    then
        echo "Repository: $dirName"
        gh repo clone $repo "$dirName"
    fi
done