#Column to have in CSV files "UserName","Password"

param( [parameter(Mandatory = $True)] [String] $CsvFilePath )
Import-Csv -Path $CsvFilePath | ForEach-Object { 
    $User = Get-LocalUser -Name $_.UserName -ErrorAction Ignore
    if ($User -eq $null) {
        $secureString = ConvertTo-SecureString $_.Password -AsPlainText -Force
        New-LocalUser -Name $_.UserName -Password $secureString -PasswordNeverExpires -UserMayNotChangePassword
        Add-LocalGroupMember -Group "Administrators" -Member $_.UserName
    }
}
