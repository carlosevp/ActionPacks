﻿#Requires -Version 5.0
#Requires -Modules @{ModuleName = "microsoftteams"; ModuleVersion = "1.1.4"}

<#
.SYNOPSIS
    Generates a report with the group policy assignments

.DESCRIPTION

.NOTES
    This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
    The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
    The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
    the use and the consequences of the use of this freely available script.
    PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
    © ScriptRunner Software GmbH

.COMPONENT
    Requires Module microsoftteams 1.1.4 or greater
    Requires Library script MSTLibrary.ps1
    Requires Library Script ReportLibrary from the Action Pack Reporting\_LIB_

.LINK
    https://github.com/scriptrunner/ActionPacks/tree/master/O365/MS-Teams/_REPORTS_
 
.Parameter MSTCredential
    [sr-en] Provides the user ID and password for organizational ID credentials
    [sr-de] Enthält den Benutzernamen und das Passwort für die Anmeldung
    
.Parameter GroupId 
    [sr-en] Specify the specific GroupId
    [sr-de] Gibt die Gruppen-Id an
    
.Parameter PolicyType
    [sr-en] The type of the policy package
    [sr-de] Typ des Ploiciy Pakets    

.Parameter TenantID
    [sr-en] Specifies the ID of a tenant
    [sr-de] ID eines Mandanten
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true)]   
    [pscredential]$MSTCredential,
    [string]$GroupId,
    [ValidateSet('TeamsAppSetupPolicy', 'TeamsCallingPolicy', 'TeamsCallParkPolicy', 'TeamsChannelsPolicy', 'TeamsComplianceRecordingPolicy', 'TeamsEducationAssignmentsAppPolicy', 'TeamsMeetingBroadcastPolicy', 'TeamsMeetingPolicy', 'TeamsMessagingPolicy')]
    [string]$PolicyType,
    [string]$TenantID
)

Import-Module microsoftteams

try{
    ConnectMSTeams -MTCredential $MSTCredential -TenantID $TenantID

    [hashtable]$getArgs = @{'ErrorAction' = 'Stop'}  
                            
    if([System.String]::IsNullOrWhiteSpace($PolicyType) -eq $false){
        $getArgs.Add('PolicyType',$PolicyType)
    }
    if([System.String]::IsNullOrWhiteSpace($GroupId) -eq $false){
        $getArgs.Add('GroupId', $GroupId)
    }

    $result = Get-CsGroupPolicyAssignment @getArgs | Select-Object *
    
    ConvertTo-ResultHtml -Result $result
}
catch{
    throw
}
finally{
    DisconnectMSTeams
}