# This is a PowerShell comment
# Set-ExecutionPolicy RemoteSigned
# Set-ExecutionPolicy default
# The-Root is a lost cause

$global:UNIVERSE_COUNT = 17

write-debug "Universe Count ($global:UNIVERSE_COUNT)"

function MyFunction([Parameter(Position = 0)][System.String]$path)
{
    :loopLabel foreach ($thisFile in (Get-ChildItem $path))
    {
        Write-Host ; Write-Host -Fore Yellow `
            ('Length:' +
            [System.Math]::Floor($thisFile.Length / 1000))
    }
}

function GUIDFunction([Parameter(Position = 0)][System.String]$path)
{
    :label for ($x = 1;  $x -lt $global:UNIVERSE_COUNT; $x++)
    {
        #Write-Host -NoNewline 'xá';
        #[void][guid]::newGuid()
        $test = [guid]::newGuid()
        Write-Host $test
        #|out-null
    }
}

function MoietyToiety([Parameter(Position = 0)][System.String]$fundip='yum')
{
    Write-Output $fundip
    [void]
    Write-Host -Fore Red `-=+=--=+=--=+=--=+=-=+=--=+=--+x
    Write-Host -Fore Red `-=+=--=+=--=+=--=+=-=+=--=+=--+x
}

function Intro([Parameter(Position = 0)][System.Int64]$X)
{
    Write-Host ; Write-Host -Fore Yellow `----->beginning upgrade[serialized]
    Write-Host -NoNewLine -Fore DarkGray `-=+=-
    Write-Host -Fore Red `-=+=--=+=--=+=--=+=-=+=--=+=--+x
    Write-Host -NoNewline -Fore Cyan `Qi/xá 
    Write-Host -Fore Red `XXX-XX-XXXX    \\<0\\?\\>      $X • $X • $X
    Write-Host -NoNewLine -Fore DarkGray `-=+=-
    Write-Host -Fore Red `-=+=--=+=--=+=--=+=--=+=--=+=--+
    #Write-Information -MessageData "press any key" -InformationAction Continue    
}

Function Send-TCPMessage { 
    Param ( 
            [Parameter(Mandatory=$true, Position=0)]
            [ValidateNotNullOrEmpty()] 
            [string] 
            $EndPoint
        , 
            [Parameter(Mandatory=$true, Position=1)]
            [int]
            $Port
        , 
            [Parameter(Mandatory=$true, Position=2)]
            [string]
            $Message
    ) 
    Process {
        # Setup connection 
        $IP = [System.Net.Dns]::GetHostAddresses($EndPoint) 
        $Address = [System.Net.IPAddress]::Parse($IP) 
        $Socket = New-Object System.Net.Sockets.TCPClient($Address,$Port) 
    
        # Setup stream wrtier 
        $Stream = $Socket.GetStream() 
        $Writer = New-Object System.IO.StreamWriter($Stream)

        # Write message to stream
        $Message | % {
            $Writer.WriteLine($_)
            $Writer.Flush()
        }
    
        # Close connection and stream
        $Stream.Close()
        $Socket.Close()
    }
}

Function Receive-TCPMessage {
    Param ( 
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()] 
        [int] $Port
    ) 
    Process {
        Try { 
            # Set up endpoint and start listening
            $endpoint = new-object System.Net.IPEndPoint([ipaddress]::any,$port) 
            $listener = new-object System.Net.Sockets.TcpListener $EndPoint
            $listener.start() 
 
            # Wait for an incoming connection 
            $data = $listener.AcceptTcpClient() 
        
            # Stream setup
            $stream = $data.GetStream() 
            $bytes = New-Object System.Byte[] 1024

            # Read data from stream and write it to host
            while (($i = $stream.Read($bytes,0,$bytes.Length)) -ne 0){
                $EncodedText = New-Object System.Text.ASCIIEncoding
                $data = $EncodedText.GetString($bytes,0, $i)
                Write-Output $data
            }
         
            # Close TCP connection and stop listening
            $stream.close()
            $listener.stop()
        }
        Catch {
            "Receive Message failed with: `n" + $Error[0]
        }
    }
}

#MoietyToiety("0")
#MoietyToiety("1")
#MoietyToiety("2")
#MoietyToiety("yum")
Intro(0)
GUIDFunction(5)

write-debug DEBUG
exit

#Get-NetIPAddress -AddressFamily IPV4
[int] $Port = 4201
#$IP = "10.10.1.100" 
$IP = "127.0.0.1"
$Address = [system.net.IPAddress]::Parse($IP) 

# Set up endpoint and start listening
$endpoint = new-object System.Net.IPEndPoint($Address, $Port) 
$listener = new-object System.Net.Sockets.TcpListener $EndPoint
$listener.start() 

#Write-Output $port
#Write-Output $endpoint
#Write-Output $listener

###
# Wait for an incoming connection 
$data = $listener.AcceptTcpClient() 
        
# Stream setup
$stream = $data.GetStream() 
$bytes = New-Object System.Byte[] 1024

# Read data from stream and write it to host
while (($i = $stream.Read($bytes,0,$bytes.Length)) -ne 0){
    $EncodedText = New-Object System.Text.ASCIIEncoding
    $data = $EncodedText.GetString($bytes,0, $i)
    Write-Output $data
}
         
# Close TCP connection and stop listening
$stream.close()
###

$listener.stop()

###
# Port Signals 6-2021
# OnConnect TCP (Port) fire Signal style interrupt.  
# OnPacket UDP (IP/Port) fire Signal style interrupt.   vs2.


###
# Listen Socket
#  Process Listen Socket
#    Create InputSocket[Client.x]
# Process InputSockets [List]
#  Convert Stream Input To Handle
#    Process Handle
#      Gather Output
#    Dispatch Output


###
# InputSocket.Types
#   User
#   Sysop
#   Server
#   Stargate