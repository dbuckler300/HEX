# Simple program to listen on a port
# 
#
param (
    [Parameter(Mandatory=$false, Position=0)][int]$global:port = 80    
 ) 
 
 $global:listener = $global:null
 $global:endpoint = $global:null
 $global:stream = $global:null

 function nbegin([Parameter(Position = 0)][int]$X)
 {
    # Set up endpoint and start listening
    $global:endpoint = new-object System.Net.IPEndPoint([ipaddress]::any,$global:port)
    $global:listener = new-object System.Net.Sockets.TcpListener $global:endpoint
    $global:listener.start()
    write-output "<< Port open [$global:port][$global:endpoint]"
 }

 function nend([Parameter(Position = 0)][int]$X)
 {
    # Close connection and stream
    if ($global:stream) {$global:stream.Close()}        
    if ($global:listener) {$global:listener.Stop()}
 }

function tell([Parameter(Position = 0)][int]$X)
{    
    if ($global:listener.Pending()) {
        write-output [flag found]
        $tcpdata = $global:listener.AcceptTcpClient() 
        # Stream setup
        $global:stream = $tcpdata.GetStream() 
        $bytes = New-Object System.Byte[] 1024

        # Read data from stream and write it to host
        while (($i = $global:stream.Read($bytes,0,$bytes.Length)) -ne 0){
            $EncodedText = New-Object System.Text.ASCIIEncoding
            $msg = $EncodedText.GetString($bytes,0, $i)
            Write-Host "$msg"
        }
    }   
}

if (Test-Path -Path .\.port -PathType Leaf) {
    write-output "current working directory .port file being obeyed"
}

#write-output $Host

nbegin($global:port)

while(1) {     
    if ($Host.UI.RawUI.KeyAvailable -and (3 -eq [int]$Host.UI.RawUI.ReadKey("AllowCtrlC,IncludeKeyUp,NoEcho").Character))
    {
            Write-Host "You pressed CTRL-C" 
            $key = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
            if ($key.Character -eq "N") { break; }
    }
    $var = tell($global:null)    
    sleep(0)
}

nend($global:null)