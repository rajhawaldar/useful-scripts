# This script will add "Delete lock" to all the resources that the user has access to.
# Before executing the script do run "az login" in the console.

Get-AzResourceGroup | Select-Object ResourceGroupName |
ForEach-Object {
    Get-AzResource -ResourceGroupName $_.ResourceGroupName |
    ForEach-Object {
        Set-AzResourceLock -LockName "Do-Not-Delete" -LockLevel CanNotDelete -ResourceName $_.Name -ResourceGroupName $_.ResourceGroupName -ResourceType $_.ResourceType -Force 
    } 
}


