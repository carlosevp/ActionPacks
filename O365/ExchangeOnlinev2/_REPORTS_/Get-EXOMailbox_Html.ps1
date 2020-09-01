﻿#Requires -Version 5.0
#Requires -Modules ExchangeOnlineManagement

<#
    .SYNOPSIS
        Gets the mailbox objects and attributes
    
    .DESCRIPTION  

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT       
        Requires PS Module ExchangeOnlineManagement
        Requires Library Script ReportLibrary from the Action Pack Reporting\_LIB_

    .LINK
        https://github.com/scriptrunner/ActionPacks/tree/master/O365/ExchangeOnlinev2/_Reports_

    .Parameter Identity
        Specifies name, Guid or UPN of the mailbox
        [sr-de] Name, Guid oder UPN des Postfachs
    
    .Parameter AnrSearch
        Specifies a partial string for search objects with an attribute that matches that string. 
        The default attributes searched are: CommonName, DisplayName, FirstName, LastName, Alias
        [sr-de] Teilzeichenfolge für die Suche in einem Attribut. 
        Die standardmäßig durchsuchten Attribute sind CommonName, DisplayName, Vorname, Nachname, Alias        

    .Parameter Archive
        Returns only mailboxes that have an archive mailbox
        [sr-de] Filtert die Ergebnisse nach Postfächern, für die ein Archiv aktiv ist

    .Parameter InactiveMailboxOnly
        Returns only inactive mailboxes
        [sr-de] Gibt an, das nur inaktive Postfächer in den Ergebnissen zurückgegeben werden

    .Parameter IncludeInactiveMailbox
        Include inactive mailboxes in the result
        [sr-de] Gibt an, das inaktive Postfächer in den Ergebnissen zurückgegeben werden

    .Parameter SoftDeletedMailbox
        Inculde soft-deleted mailboxes in the result
        [sr-de] Gibt an, das vorläufig gelöschte Postfächer in den Ergebnissen zurückgegeben werden

    .Parameter RecipientTypeDetails
        Filters the result by the specified mailbox subtypes
        [sr-de] Filtert die Ergebnisse nach dem angegebenen Postfach Untertyp

    .Parameter ResultSize
        Specifies the maximum number of results to return
        [sr-de] Gibt die maximale Anzahl der zurückzugegebenen Ergebnisse an

    .Parameter PropertySets
        Specifies a logical grouping of properties
        [sr-de] Gibt eine logische Gruppierung von Eigenschaften an
    
    .Parameter Properties
        List of properties to expand. Use * for all properties
        [sr-de] Liste der zu anzuzeigenden Eigenschaften. Verwenden Sie * für alle Eigenschaften
#>

param(
    [Parameter(ParameterSetName = 'Default')]
    [string]$Identity,
    [Parameter(Mandatory=$true,ParameterSetName = 'Search')]
    [string]$AnrSearch,
    [Parameter(ParameterSetName = 'Default')]
    [Parameter(ParameterSetName = 'Search')]
    [switch]$Archive,
    [Parameter(ParameterSetName = 'Default')]
    [Parameter(ParameterSetName = 'Search')]
    [switch]$InactiveMailboxOnly,
    [Parameter(ParameterSetName = 'Default')]
    [Parameter(ParameterSetName = 'Search')]
    [switch]$IncludeInactiveMailbox,
    [Parameter(ParameterSetName = 'Default')]
    [Parameter(ParameterSetName = 'Search')]
    [switch]$SoftDeletedMailbox,
    [Parameter(ParameterSetName = 'Default')]
    [Parameter(ParameterSetName = 'Search')]
    [ValidateSet('DiscoveryMailbox','EquipmentMailbox','GroupMailbox','LegacyMailbox','LinkedMailbox','LinkedRoomMailbox','RoomMailbox','SchedulingMailbox','SharedMailbox','TeamMailbox','UserMailbox')]
    [string[]]$RecipientTypeDetails,
    [Parameter(ParameterSetName = 'Default')]
    [Parameter(ParameterSetName = 'Search')]
    [int]$ResultSize = 1000,
    [Parameter(ParameterSetName = 'Default')]
    [Parameter(ParameterSetName = 'Search')]
    [ValidateSet('Minimum','All','AddressList','Archive','Audit','Custom','Hold','Delivery','Moderation','Move','Policy','PublicFolder','Quota','Resource','Retention','SCL','SoftDelete','StatisticsSeed')]
    [string]$PropertySets = 'Minimum',
    [Parameter(ParameterSetName = 'Default')]
    [Parameter(ParameterSetName = 'Search')]
    [ValidateSet('*','Name','Identity','Id','UserPrincipalName','Alias','DisplayName','PrimarySmtpAddress','DistinguishedName','RecipientType','EmailAddresses','Guid')]
    [string[]]$Properties =  @('Name','Identity','UserPrincipalName','Alias','DisplayName','PrimarySmtpAddress')
)

Import-Module ExchangeOnlineManagement

try{
    if($Properties -contains '*'){
        $Properties = @('*')
    }

    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                    'ResultSize' = $ResultSize
                    'PropertySets' = $PropertySets
                    'Archive' = $Archive
                    'InactiveMailboxOnly' = $InactiveMailboxOnly
                    'IncludeInactiveMailbox' = $IncludeInactiveMailbox
                    'SoftDeletedMailbox' = $SoftDeletedMailbox
    }
    
    if($PSCmdlet.ParameterSetName -eq 'Search'){
        $cmdArgs.Add('Anr',$AnrSearch)
    }
    if([System.String]::IsNullOrWhiteSpace($Identity) -eq $false){
        $cmdArgs.Add('Identity',$Identity)
    }
    if($PSBoundParameters.ContainsKey('RecipientTypeDetails') -eq $true){
        $cmdArgs.Add('RecipientTypeDetails',$RecipientTypeDetails)
    }

    $box = Get-EXOMailbox @cmdArgs | Select-Object $Properties   
    ConvertTo-ResultHtml -Result $box
}
catch{
    throw
}
finally{
    
}