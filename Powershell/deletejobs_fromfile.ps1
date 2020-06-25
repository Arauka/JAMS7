#Run from JAMS server
Import-Module JAMS
#Get jobs to delete from file
$LookUp = Get-Content -Path .\Jobs_ToDelete.txt

#Results file:
$results = 'Results.txt'

#Loops through file
foreach ($lu in $LookUp){ 
    $jobName, $source = $lu.split('|') 
   
	#Get object job
	$job = Get-ChildItem JAMS::localhost$source -ObjectType job -Recurse -IgnorePredefined | where-object {($_.Name -eq $jobName)}
		
	$homedirectory = $job.HomeDirectory
	
	#Check null
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
			#This removes folder
			#Remove-Item –path $homedirectory –recurse				
            homedirectory.Substring($homedirectory.LastIndexOf('\',$homedirectory.LastIndexOf('\')-1),$homedirectory.Length-$homedirectory.LastIndexOf('\',$homedirectory.LastIndexOf('\')-1))	
		}	
	}
}