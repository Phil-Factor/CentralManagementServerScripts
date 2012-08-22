#Load SMO assemblies
$CentralManagementServer = "andrewctest.testnet.red-gate.com\sql2008"
$MS='Microsoft.SQLServer'
@('.SMO', '.Management.RegisteredServers', '.ConnectionInfo') |
     foreach-object {if ([System.Reflection.Assembly]::LoadWithPartialName("$MS$_") -eq $null) {"missing SMO component $MS$_"}}

$connectionString = "Data Source=$CentralManagementServer;Initial Catalog=master;Integrated Security=SSPI;"
$sqlConnection = new-object System.Data.SqlClient.SqlConnection($connectionString)
$conn = new-object Microsoft.SqlServer.Management.Common.ServerConnection($sqlConnection)
$CentralManagementServerStore = new-object Microsoft.SqlServer.Management.RegisteredServers.RegisteredServersStore($conn)

#$CentralManagementServerStore.ServerGroups

$My="$ms.Management.Smo" #
$CentralManagementServerStore.ServerGroups["DatabaseEngineServerGroup"].ServerGroups["BackUpEverythin"].RegisteredServers|
   Foreach-object {new-object ("$My.Server") $_.ServerName } | # create an SMO server object
     Where-Object {$_.ServerType -ne $null} | # did you positively get the server?
       Foreach-object {$_.Logins } | #logins for every server successfully reached 
           Select-object @{Name="Server"; Expression={$_.parent}}, Name, DefaultDatabase , CreateDate, DateLastModified   |
              format-table


"did that work"


