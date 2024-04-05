#region snmpwalk command
$snmpwalk = New-CrescendoCommand -Verb Start -Noun Snmpwalk -OriginalName snmpwalk

$parameters = @(
($v = New-ParameterInfo -Name Version -OriginalName '-v')
($c = New-ParameterInfo -Name Community -OriginalName '-c')
($t = New-ParameterInfo -Name Target -OriginalName $null)
($o = New-ParameterInfo -Name Oid -OriginalName $null)
)

$handler = {
    param([object[]]$lines)

    $lines | Foreach-Object {
        $matcher = '(?<oid>(.*?))\s=\s(?<type>\w+(?=:)):\s(?<value>.+)'
        #Match current item in pipeline to my regex matcher above. Automatically added to $matches
        $null = $_ -match $matcher

        [pscustomobject]@{
            Oid   = $Matches.oid
            Type  = $Matches.type
            Value = $Matches.value
        }
    }
}


$OutputHandler = New-OutputHandler
$OutputHandler.ParameterSetName = 'Default'
$OutputHandler.Handler = $handler.ToString()
$OutputHandler.HandlerType = 'Inline'

$OutputHandler.Handler

#Doctor things a bit
$v.NoGap = $true
$snmpwalk.Parameters = $parameters
$snmpwalk.OutputHandlers = $OutputHandler

#Produce the json schema file
$snmpwalk | Export-CrescendoCommand
#endregion

#region snmpbulkwalk command
$snmpbulkwalk = New-CrescendoCommand -Verb Start -Noun Snmpbulkwalk -OriginalName snmpbulkwalk

$parameters = @(
($v = New-ParameterInfo -Name Version -OriginalName '-v')
($c = New-ParameterInfo -Name Community -OriginalName '-c')
($t = New-ParameterInfo -Name Target -OriginalName $null)
($o = New-ParameterInfo -Name Oid -OriginalName $null)
)

$handler = {
    param([object[]]$lines)

    $lines | Foreach-Object {
        $matcher = '(?<oid>(.*?))\s=\s(?<type>\w+(?=:)):\s(?<value>.+)'
        $null = $_ -match $matcher
        [pscustomobject]@{
            Oid   = $Matches.oid
            Type  = $Matches.type
            Value = $Matches.value
        }
    }
}
$OutputHandler = New-OutputHandler
$OutputHandler.ParameterSetName = 'Default'
$OutputHandler.Handler = $handler.ToString()
$OutputHandler.HandlerType = 'Inline'

$OutputHandler.Handler

#Doctor things a bit
$v.NoGap = $true
$snmpbulkwalk.Parameters = $parameters
$snmpbulkwalk.OutputHandlers = $OutputHandler

#Produce the json schema file
Export-CrescendoCommand -Command $snmpbulkwalk
#endregion