#region Explain OIDs
<#
1 #ISO, the group that made the standard
.3 #An org will be specified
.6 #Department of Defense (yes, that's how old this shit is)
.1 #Communication will be over the network/internet
.4 #Device is manufactured by a private entity
.1 #Manufacturer is classified as an enterprise (Cisco, Dell, APC, Ubiquiti, etc etc etc)

After that it becomes the wild west as you get into device manufactures/types/trees

Let's look at a real example

.1.3.6.1.4.1 #We explained this above

.9.9.87.1.1.9.0 #so what's the rest?

.9 Cisco manufacturer, because the preceding .1 said it was a private enterprise
.9 This is a switch device
.87 This is the CISCO-C2900-MIB tree
.1 MIB objects
.1 System information
.9 Redundant Power SUpply
.0 Status

Values can be 1 (absent), 2, (connectedFunctionaL), 3 (connectedNotFunctional), or 4 (functionalPrimaryFailed)

#>
#end region

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

snmpwalk -v1 -On -c public 172.16.115.144 .1.3.6.1.2.1.25.6.3.1.2