#!/bin/bash

# below code will configure aks clusters from all the az subscriptions to which you have access
# prerequisites : Install kubelogin and az-cli on your host
# login to azure
az login

subscriptions=$(az account list --output tsv --query '[].id')
for subscription in $subscriptions
do
    echo "Checking subscription: $subscription"
    az account set --subscription $subscription
    clusters=$(az aks list | jq -c '.[] | {"name" : .name,"resourceGroup": .resourceGroup}')
    for cluster in $clusters
    do
        resourceGroup=$(echo $cluster | jq -r '.resourceGroup')
        cluster=$(echo $cluster | jq -r '.name')
        echo "Setting context for cluster: $cluster"
        az aks get-credentials --resource-group $resourceGroup --name $cluster --overwrite-existing
        kubelogin convert-kubeconfig -l azurecli
    done
done