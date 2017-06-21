# Utils 1 
$y = "yellow" 
$w = "white" 
$c = "cyan" 
$g = "green" 

# Read the csv file  
$logfile = "C:\logging\Add_records_list.txt" 
$list    = "C:\DNS_Bulk_remove.csv"  
$lcount  = (Import-CSV -Path $list).count 
$list_1  = Import-CSV -Path $list 


# (0) 
write-host -f $w "===========$d=============" 
write-host -f $c " Importing Records        " 
write-host -f $w "===========$d=============" 
write-host $null 
 
# (1) 
Write-host -f $y "1_.Make sure CSV exists" 
 
# Check to make sure csv file exit if not 
If (Test-Path $list ){ 
  Write-host -f $y " (a)_Located CSV File" 
}Else{ 
  write-host -f $r " (b)_If CSV not located 
  write-host -f $r " (c)_Script exits in 5 seconds" 
  exit 
} 
write-host $null 
Write-host -f $y "a_.$Lcount DNS Records located" 
Write-host -f $y "b_.Will read first 3 records" 
 
# Reading first record to show CSV headers 
Write-host "##############CSV Columns#######################" 
$list_1 | Select-Object -First 1 | ft -AutoSize 
Write-host "################################################" 
write-host $null 
 
# (2) 
Write-host -f $y "2_.Starting Bulk DNS removal" 
$list_1 | ForEach{  
 
# Adding Records 
#Get-DnsServerResourceRecord -ZoneName $_.zone -ComputerName $_.DNSServer -RRType "CNAME" -ErrorAction SilentlyContinue -Node
Remove-DnsServerResourceRecord -ZoneName $_.zone -ComputerName $_.DNSServer -Force -RRType "CNAME" -Name $_.name
 
# Providing Information  
write-Host -f $g  "$("$_.name") removed successfully on $($_."Zone")"  
 
# write to Output results 
write "$("$_.name") removed successfully" | Out-File -Append $logfile 
} 
 
write-host $null 
# (3) 
Write-host -f $y "3_.Total $Lcount DNS Records Removed." 
Write-host -f $y "4_.Log file is located on " 
Write-host -f $w "$logfile" 
