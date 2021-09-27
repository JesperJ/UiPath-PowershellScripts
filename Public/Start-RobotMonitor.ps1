function Start-RobotMonitor {
    <#
    .SYNOPSIS
    Show screen of UiPath Robot if remote session is active
    
    .DESCRIPTION
    Monitor UiPath Robot for remote sessions. When a remote session is active automatically connect to RDP shadowing to see the screen of the UiPath robot
    
    .PARAMETER Robot
    ComputerName of UiPath robot
    
    .EXAMPLE
    Start-RobotMonitor computer1
    
    .NOTES
    Needs to run with user that has remote desktop access to the machine. Also, the machine needs to allow shadowing.
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $Robot
    )
    $i = 0
    $NotConnected = $true
    $RunLoop = $true
    Clear-Host
    "$(Get-Date -UFormat "[%Y-%m-%d %R]") - Monitor Robot $Robot started."
    
    while ($RunLoop -eq $true) {
        if ($MstscPID) {
            $MstscProcess = Get-Process -PID $MstscPID -ErrorAction SilentlyContinue
            if ($null -eq $MstscProcess) {
                $NotConnected = $true
                "$(Get-Date -UFormat "[%Y-%m-%d %R]") - Disconnected RDP-session on robot $Robot"
                Remove-Variable MstscPID
            }
        }
        
        $SessionID = (qwinsta /server:$Robot | ForEach-Object { (($_.trim() -replace "\s+", ",")) } | ConvertFrom-Csv | Where-Object { $_.State -eq "Active" }).Id
        if ($SessionID) {
            if ($NotConnected) {
                $NotConnected = $false
                "$(Get-Date -UFormat "[%Y-%m-%d %R]") - Connecting to RDP-session on robot $Robot"
                $arguments = @("/V:$Robot", "/shadow:$SessionID", "/noConsentPrompt")
                $MstscPID = (Start-process "mstsc" -ArgumentList $arguments -PassThru).Id
            }
            Remove-Variable SessionID
        }
        else {
            $NotConnected = $true
        }
        
        start-sleep 5
        $i++;
    }
}
