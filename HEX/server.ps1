# Simple server program that handles incomming connections and a worldbeat.  "think heartbeat, but server."
# 
#
param (
    [Parameter(Mandatory=$false, Position=0)][int]$global:port = 80    
 ) 
 
$global:listener = $global:null
$global:endpoint = $global:null
$global:stream = $global:null
$global:comlist = New-Object System.Collections.ArrayList  #interesting, Arrays are actually global scope, ArrayList is program local scope

$mdarray1 = @()

function ndebugbegin([Parameter(Position = 0)][int]$X)
{
$mdarray1 = @()
$mdarray1_counter ++
$mdarray1 += ,@($mdarray1_counter, 'Earth',12742)
$mdarray1_counter ++
$mdarray1 += ,@($mdarray1_counter, 'Mars',6779)
$mdarray1_counterr ++
$mdarray1 += ,@($mdarray1_counter, 'Venus',12104)
$mdarray1_counter ++
$mdarray1 += ,@($mdarray1_counter, 'Saturn',116464)
}

 function nbegin([Parameter(Position = 0)][int]$X)
 {
#   ndebugbegin(0)
    # Set up endpoint and start listening
    $global:endpoint = new-object System.Net.IPEndPoint([ipaddress]::any,$global:port)
    $global:listener = new-object System.Net.Sockets.TcpListener $global:endpoint
    try {$global:listener.start()}
    catch {
        "Error starting to listen on port [$global:port].  In Use?"
        "$global:endpoint"
        exit(-1)
    }

    write-output "<< Port open [$global:port][$global:endpoint]"
    #$global:comlist.Add("Bacon")
    #$global:comlist.Add(5)
    #$global:comlist.Add("Eggs")
    write-output "<< comlist[$global:comlist.Count]"
 }

 function nend([Parameter(Position = 0)][int]$X)
 {
    write-ouput "system shutdown"
    # Close connection and stream
    finally {
        write-ouput $global:listener
        $global:listener.Stop()
    }
    $global:stream.Close()        
    $global:comlist.Clear()
 }

function npintch([Parameter(Position = 0)][int]$X)
{
    #Write-Host "PINCH:" $global:comlist.Count
    #Write-Host "--"

}

function incoming([Parameter(Position = 0)][System.Net.Sockets.TcpClient]$X)
{
    # Stream setup
    $global:stream = $X.GetStream() 
    $bytes = New-Object System.Byte[] 1024

    # Read data from stream and write it to host
    while (($i = $global:stream.Read($bytes,0,$bytes.Length)) -ne 0){
        $EncodedText = New-Object System.Text.ASCIIEncoding
        $msg = $EncodedText.GetString($bytes,0, $i)
        Write-Host "$msg"
    }
}

function tell([Parameter(Position = 0)][int]$X)
{    
    if ($global:listener.Pending()) {
        write-output [flag found]
        $tcpdata = $global:listener.AcceptTcpClient() 

        $global:comlist.Add($tcpdata)

        incoming($tcpdata)
    }else{
        write-output "Socket isn't pending anything..."        
    }
}

function nnotice ($message)
{
    # Check if running Powershell ISE
    if ($psISE)
    {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show("$message")
    }
    else
    {
        Write-Host "$message" -ForegroundColor Yellow
        $x = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

if (Test-Path -Path .\.port -PathType Leaf) {
    write-output "current working directory .port file being obeyed"
}

nbegin($global:port)
$snack = 0
$tick = 0
try {
    do {     
        $tick++

        ## I don't trust this code
        if ($Host.UI.RawUI.KeyAvailable -and (3 -eq [int]$Host.UI.RawUI.ReadKey("AllowCtrlC,IncludeKeyUp,NoEcho").Character))
        {  
            nnotice("411!")
           Write-Host "You pressed CTRL-C" 
           break dred
           $key = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
           $snack = 4
           if ($key.Character -eq "N") { write-output "OP" 
                                            $snack = 4 }
           break dred
        }
        ## TRUST TRUST??
        write-debug "TICK $tick"
        $var = tell($global:null)    
        $another_var = npintch($global:null)    
        # Read in all com
        foreach ($X in $global:comlist) {
            try {
                if ($X -is [System.Net.Sockets.TcpClient]) {
                incoming($X)
                    #write-output ($global:comlist.Count)
                } else {
                   #write-output "Ignoring invalid array entry."
                }
            } catch {
                write-output "Meat and Potatoe's Error"
            }
        }

        sleep(0)
    }
    while($snack -eq 0)
    }

finally {
nend($global:null)

write-output "END OF LINE"
}