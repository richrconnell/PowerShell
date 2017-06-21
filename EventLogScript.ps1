Set-Variable -Name EventAgeDays -Value 1     #we will take events for the latest 7 days
    Set-Variable -Name CompArr -Value @("localhost")   # replace it with your server names
    Set-Variable -Name LogNames -Value @("Application", "System")  # Checking app and system logs
    Set-Variable -Name EventTypes -Value @("1")  # Loading only Errors and Warnings
    Set-Variable -Name ExportFolder -Value "C:\users\connell\documents\Winevents.csv"


    $el_c = @()   #consolidated error log
    $now=get-date
    $startdate=$now.adddays(-$EventAgeDays)
    $ExportFile=$ExportFolder + "el" + $now.ToString("yyyy-MM-dd---hh-mm-ss") + ".csv"  # we cannot use standard delimiteds like ":"

    foreach($comp in $CompArr)
    {
      foreach($log in $LogNames)
      {
        Write-Host Processing $comp\$log
        $el = get-winevent -ComputerName $comp -FilterHashtable @{logname="$log";level=$eventtypes;starttime=$startdate}
        $el_c += $el  #consolidating
      }
    }
    $el_sorted = $el_c | Sort-Object TimeGenerated    #sort by time
    #Write-Host Exporting to $ExportFile
    $el_sorted|Select LevelDisplayName, TimeCreated, ProviderName, ID, MachineName, Message 

    Get-Process | Export-CSV c:\users\connell\documents\Process.csv
    
    ps | sort –p ws | select –last 5
