#Requires -Modules AzureAD

<#
    .SYNOPSIS
        Connect to Azure Active Directory and enables the role
        Requirements 
        ScriptRunner Version 4.x or higher
        64-bit OS for all Modules 
        Microsoft Online Sign-In Assistant for IT Professionals  
        Azure Active Directory Powershell Module v2
    
    .DESCRIPTION  

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, AppSphere AG assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of AppSphere AG.
        © AppSphere AG

    .Parameter RoleName
        Specifies the display name of the role to which to enable
#>

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('Application Administrator','Application Developer','Billing Administrator','Cloud Application Administrator','Cloud Application Administrator',
    'Company Administrator','Compliance Administrator','Conditional Access Administrator','CRM Service Administrator','Customer LockBox Access Approver',
    'Device Administrators','Device Join','Device Managers','Device Users','Directory Readers','Directory Synchronization Accounts','Directory Writers',
    'Exchange Service Administrator','Guest Inviter','Helpdesk Administrator','Intune Service Administrator','Lync Service Administrator','Partner Tier1 Support',
    'Partner Tier2 Support','Power BI Service Administrator','Privileged Role Administrator','Security Administrator','Security Reader','Service Support Administrator',
    'SharePoint Service Administrator','User','User Account Administrator','Workplace Device Join')]
    [string[]]$RoleName
)
try{
    # Get directory role template
    $roleTemplate = Get-AzureADDirectoryRoleTemplate | Where-Object { $_.DisplayName -eq $RoleName }

    # Enable an instance of the DirectoryRole template
    Enable-AzureADDirectoryRole -RoleTemplateId $roleTemplate.ObjectId
    
    if($SRXEnv) {
        $SRXEnv.ResultMessage = "Role: $($RoleName) enabled"
    } 
    else{
        Write-Output "Role: $($RoleName) enabled"
    }
}
finally{
   
}