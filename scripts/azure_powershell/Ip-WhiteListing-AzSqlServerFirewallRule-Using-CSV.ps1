param([parameter(Mandatory = $True)] [String] $FilePath,[parameter(Mandatory=$True)] [String] $ResourceGroupName, [parameter(Mandatory=$True)] [String] $ServerName )

# The csv file contains two columns UserName and PublicIP

Install-Module -Name ImportExcel -Force
$data = Import-Excel -Path $FilePath

function IpWhiteListing() {

    foreach ($row in $data) {
        If ( $null -eq (Get-AzSqlServerFirewallRule -FirewallRuleName $row.UserName -ResourceGroupName $ResourceGroupName -ServerName $ServerName -ErrorAction SilentlyContinue) )  
        {
            New-AzSqlServerFirewallRule -ResourceGroupName $ResourceGroupName -ServerName $ServerName -FirewallRuleName $row.UserName -StartIPAddress $row.PublicIP -EndIPAddress $row.PublicIP
        } 
        else 
        {
            If ((Get-AzSqlServerFirewallRule -FirewallRuleName $row.UserName -ResourceGroupName $ResourceGroupName -ServerName $ServerName).StartIpAddress -ne $row.PublicIP ) 
            {
                Write-Host "Updated"
                Set-AzSqlServerFirewallRule  -ResourceGroupName $ResourceGroupName -ServerName $ServerName -FirewallRuleName $row.UserName -StartIPAddress $row.PublicIP -EndIPAddress $row.PublicIP
            }        
        }
    }
}
