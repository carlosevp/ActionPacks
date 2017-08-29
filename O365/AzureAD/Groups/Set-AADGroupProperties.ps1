﻿#Requires -Modules AzureAD

<#
    .SYNOPSIS
        Connect to Azure Active Directory and updates the properties of the group.
        Only parameters with value are set
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

    .Parameter GroupObjectId
        Specifies the unique ID of the group to update

    .Parameter GroupName
        Specifies the display name of the group to update

    .Parameter Description
        Specifies a description of the group

    .Parameter DisplayName
        Specifies the new display name of the group
#>

param(
    [Parameter(Mandatory = $true,ParameterSetName = "Group object id")]
    [guid]$GroupObjectId,
    [Parameter(Mandatory = $true,ParameterSetName = "Group name")]
    [string]$GroupName,
    [Parameter(ParameterSetName = "Group name")]
    [Parameter(ParameterSetName = "Group object id")]
    [string]$Description,
    [Parameter(ParameterSetName = "Group name")]
    [Parameter(ParameterSetName = "Group object id")]
    [string]$DisplayName
)

try{
    $Script:Grp
    if($PSCmdlet.ParameterSetName  -eq "Group object id"){
        $Script:Grp = Get-AzureADGroup -ObjectId $GroupObjectId
    }
    else{
        $Script:Grp = Get-AzureADGroup -All $true | Where-Object {$_.Displayname -eq $GroupName} 
    }
    if($null -ne $Script:Grp){
        if(-not [System.String]::IsNullOrWhiteSpace($Description)){
            Set-AzureADGroup -ObjectId $Script:Grp.ObjectId -Description $Description
        }
        if(-not [System.String]::IsNullOrWhiteSpace($DisplayName)){
            Set-AzureADGroup -ObjectId $Script:Grp.ObjectId -DisplayName $DisplayName
        }
        if($SRXEnv) {
            $SRXEnv.ResultMessage = "Group $($Script:Grp.DisplayName) changed"
        } 
        else{
            Write-Output  "Group $($Script:Grp.DisplayName) changed"
        }
    }
    else{
        if($SRXEnv) {
            $SRXEnv.ResultMessage = "Group not found"
        }    
        Throw "Group not found"
    }
}
finally{
 
}