$users = Get-ChildItem c:\users | ?{ $_.PSIsContainer }
foreach ($user in $users){
    $userpath = "C:\Users\$user\Downloads"
    Try{
        Remove-Item $userpath\* -Recurse  -ErrorVariable errs -ErrorAction SilentlyContinue  
    } 
    catch {
        "$errs" | Out-File c:\temp\errors.txt -append
    }
}