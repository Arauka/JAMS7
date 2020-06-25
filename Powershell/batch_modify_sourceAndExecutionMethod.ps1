Import-Module JAMS
new-psdrive JD JAMS localhost -ErrorAction SilentlyContinue

$OldMethod = "Command"
$NewMethod = "PowerShell"

#New source I wan't to push
$Source = Get-Content -Path YourOwnPathHere -raw
##JAMS path
$path = "YourJAMSPath"

#Select all jobs with old method in path
$Jobs = Get-ChildItem JD:\Feeds\$path -objectType "Job" -FullObject -Recurse -IgnorePredefined | where-object {($_.MethodName -eq $OldMethod)}

foreach ( $Job in $Jobs ){
    Write-Output "Updating $($Job.Name) From $($Job.Method)" 
	$Job.MethodName = $NewMethod    
	#Modify source if needed - In this case I replace tag |batfile| for old source
	$Source = $Source.Replace('|batfile|',$Job.Source)	
	#This updates the job
    $Job.Update()	 
}