

function Get-ComputerInfo {

    <#
    .SYNOPSIS
    Get Computer Information
    
    .DESCRIPTION
    Get Computer information for remote computers
    
    .PARAMETER RemoteComputer
    RemoteComputer
    
    .EXAMPLE
    
    Get-RemoteComputerInfo -RemoteComputer $env:COMPUTERNAME
    
    Get-RemoteComputerInfo -RemoteComputer 'Computername'
    
    run against several computers
    $Data = import-csv c:\temp\servers.csv 
    foreach($D in $Data){Get-RemoteComputerInfo -RemoteComputer $D.name}
    
    .NOTES
    General notes
    Disclaimer, run this at your own risk, supported AS-IS
    
    #>
    
    Param(
        [parameter(Mandatory=$true)]
        [String]
        $place
        )
    
    #DataCollect
    
    $Disk = Get-WMIObject -class Win32_DiskDrive
    $ComputerInfo = Get-WMIObject -class Win32_ComputerSystem
    $CPUInfo = Get-WmiObject Win32_Processor
    $PhysicalMemory = Get-WmiObject CIM_PhysicalMemory | Measure-Object -Property capacity -Sum | % {[math]::round(($_.sum / 1GB),2)} 
    $Display= Get-WmiObject Win32_VideoController
    
    $size=0
    $disk|ForEach-Object{$size+=$_.size}
    
    #Math
    $Size = $([math]::Round(((($size)/1000)/1000/1000)))
 
    #FormatOutput 
    
            $hash = @{
                    TotalDiskSize   = "$Size"               #+" GB"
                    Manufacturer    = $ComputerInfo.Manufacturer
                    Model           = $ComputerInfo.Model
                    CPU         = $CPUInfo.Name+" ("+$CPUInfo.NumberofCores+"CPUs)"
                    TotalPhysicalMem= "$PhysicalMemory"     #+ " GB"
                    Graphics   = $Display.caption
                    }        
                                        

            
    #Result
    $hash 
    New-Object -TypeName PSObject -Prop $hash | Export-CSV .\$place.csv
    
    }
    #Help Get-RemoteComputerInfo
    #Help Get-RemoteComputerInfo -Examples
    Get-ComputerInfo