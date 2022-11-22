$ResourceGroupName = "My-ResourceGroup"
$LogicApps = Get-AzLogicApp -ResourceGroupName 

#Set the state to Enabled / Disabled the logic apps.
$State="Disabled"

#Get state of existing logic apps in csv file for record purpose
$LogicApps | Select-Object Name,State  | Export-Excel ExistingStatusOfLogicApps.xlsx
ForEach-Object ( $logicApp in $LogicApps ) 
{
    Write-Host $logicApp.Name
    #Uncomment below line to run update the state of logic apps.
    Set-AzLogicApp -Name $logicApp.Name -ResourceGroupName $ResourceGroupName -state $State -Force
}