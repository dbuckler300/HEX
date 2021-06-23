# Simple telnet like program to test an ip/port
param (
    [Parameter(Mandatory=$false, Position=0)][string]$Server = "127.0.0.1",
    [Parameter(Mandatory=$false, Position=1)][int]$Port = 80,
    [Parameter(Mandatory=$false, Position=2)][string]$Message = "Default Datum"
 ) 
 
function telL([Parameter(Position = 0)][string]$dummy)
{

        write-output $Server 
        write-output $Port
        write-output $Message

        # Setup connection 
        #$IP = [System.Net.Dns]::GetHostAddresses($Server) 
        $IP = $server
        $Address = [System.Net.IPAddress]::Parse($IP) 
        try {$Socket = New-Object System.Net.Sockets.TCPClient($Address,$Port) }        
        catch [System.Net.WebException],[System.IO.IOException] {
        "Web or IO Error"
            exit
        }
        catch {
        "Standard Error, data rates may or may not apply"
            exit
        }
    
        # Setup stream wrtier 
        try {$Stream = $Socket.GetStream() }
        catch { ERROR-2 
        exit}

        try {$Writer = New-Object System.IO.StreamWriter($Stream)}
        catch { ERROR-3 
        exit}

        # Write message to stream
        $Message | % {
            $Writer.WriteLine($_)
            $Writer.Flush()
        }
        # Close connection and stream
        if ($Stream) {$Stream.Close()}        
        if ($Socket) {$Socket.Close()}
}





telL(0)