$userId = ""
$roleAssignments = Get-AzRoleAssignment -SignInName $userId
foreach ($roleAssignment in $roleAssignments) {
    Remove-AzRoleAssignment -InputObject $roleAssignment 
}