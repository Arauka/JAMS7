#Run from JAMS server
Import-Module JAMS
#Get jobs to delete from file
$LookUp = Get-Content -Path .\Jobs_ToDelete.txt

#Results file:
$results = 'Results.txt'

#Loops through file
foreach ($lu in $LookUp){ 
    $jobName, $source, $jobId = $lu.split('|') 
   
	#Get object job
	$job = Get-ChildItem JAMS::localhost$source -ObjectType job -Recurse -IgnorePredefined | where-object {($_.jobId -eq $jobId)}
		
	$homedirectory = $job.HomeDirectory
	
	#Basic checks for folder delete
	if (($homedirectory -eq $null) -or ($homedirectory -match "C:\\") -or ($homedirectory -eq "")){
		Write-Output " $($jobName) WILL NOT BE DELETED : Incomplete data" #>> $results
	}
	else{
		$homedirectory = $job.HomeDirectory.Replace('E:',"\\$($job.AgentName)")
		#Check if folder exists
		if (Test-Path($homedirectory)){		
			write-Output "Job: $($jobName) is being deleted " >> $results
			#This deletes the job
			$job | Remove-Item -Force -Confirm:$false
			
			Write-Output "Job: $($jobName) folders in $($homedirectory) are being deleted " >> $results
			#This removes folder recursively
			Remove-Item –path $homedirectory –recurse				            
		}	
	}
}