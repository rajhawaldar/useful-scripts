# If a file from $excludedFolderLocation is present in the changeset, this script will send an email message.

[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls

$$excludedFolderLocation = @("$/My/Code/Folder/Location/Web/Scripts/js",
    "$/My/Code/Folder/Location/Web/css",
)

$getChangeset = "https://dev.azure.com/xyx/xyx/_apis/tfvc/changesets?api-version=6.0";

$authToken = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("<UserName>:<PAT_TOKEN>"))

$params = @{'searchCriteria.fromDate' = '01-04-2022'; 'searchCriteria.toDate' = '01-08-2022' }
$changeSetList = (Invoke-RestMethod -Uri $getChangeset -Headers @{'Authorization' = "Basic $authToken" } -Method GET -Body $params ).value

$files = New-Object System.Collections.Generic.List[System.Object]
ForEach-Object ($changset in $changeSetList) {

    $getChanges = "https://dev.azure.com/my_org/_apis/tfvc/changesets/" + $changset.changesetId + "/changes?api-version=6.0"

    $changes = (Invoke-RestMethod -Uri $getChanges -Headers @{'Authorization' = "Basic $authToken" } -Method GET ).value 

    ForEach-Object ($change in $changes) { 
        ForEach-Object ($item in $change.item) {
            ForEach-Object($folderPath in $$excludedFolderLocation) {
                if ($item.Path.Contains($folderPath) ) {
                    $files.Add($item.Path)
                }
            }
        }  
    }
}

$files = $files | select -Unique

$body = @"  
<head>
<style>
    * {
        margin: 0;
        padding: 0;
    }
    table {
        padding: 5px;
       
    }
    th {
        background: #031d71;
        text-align: center;
        color: #ffffff;
    }
    tr{
        margin:0px;
        border: 1px solid black;
    }
    td, th {
        width: 100%;
        padding:2px 4px;
        margin: 0px;
        border: 1px solid #ddd;
    }
</style>
</head> 
"@  

$table= "<p>Hi All,<br><br> We discovered check-in within excluded folders.<br><br></p><table><tr><th>File Name</th></tr>"
ForEach-Object ( $file in $files)
{
$table+="<tr><td>"+$file+"</td></tr>"
}
# Create the message

$body+=$table+"</table><br><br>Regards,<br>Build Deployment Team"



if ( $files -ne $null ) {

    [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls
    $emailSmtpServer = "smtp.office365.com"
    $emailSmtpServerPort = "587"
    $emailSmtpUser = ""
    $emailSmtpPassword = ""
    
    $emailFrom = ""
    $recepients = @("")
    
    ForEach-Object( $emailTo in $recepients) 
    {
        $emailMessage = New-Object System.Net.Mail.MailMessage( $emailFrom , $emailTo )
        $emailMessage.Subject = "File Exclusion Check-in Alert" 
        $emailMessage.IsBodyHtml = $true #true or false depends
        $emailMessage.Body = $body
        $emailMessage.Priority = [System.Net.Mail.MailPriority]::High
        $SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer , $emailSmtpServerPort )
        $SMTPClient.EnableSsl = $True
        $SMTPClient.Credentials = New-Object System.Net.NetworkCredential( $emailSmtpUser , $emailSmtpPass );
        $SMTPClient.Send( $emailMessage )
    }
}