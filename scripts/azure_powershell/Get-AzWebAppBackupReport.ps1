Get-AzResourceGroup | Where-Object ResourceGroupName -like "prod*" |
ForEach-Object {
    Get-AzWebApp -ResourceGroupName  $_.ResourceGroupName |
    ForEach-Object {
        Get-AzWebAppBackupList -Name $_.Name -ResourceGroupName $_.ResourceGroup | Select-Object -Last 1 | Export-Csv .\Prod_Backup_Status.csv -Append
    }
}