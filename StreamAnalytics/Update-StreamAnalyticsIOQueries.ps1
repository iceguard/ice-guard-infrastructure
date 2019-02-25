#This script is intended to run on Azure Devops pipelin with a powershell session already signed into the correct subscription. If used otherwise make sure to sign in first.

$jobInputName = "IoTHubInput"
$jobInputDefinitionFile = ".\JobInputDefinition.json"
$resourceGroup = "igss-iot-backend-rg"
$jobName = "igss-streamanalytics"

New-AzStreamAnalyticsInput `
  -ResourceGroupName $resourceGroup `
  -JobName $jobName `
  -File $jobInputDefinitionFile `
  -Name $jobInputName

$jobOutputName = "BlobOutput"
$jobOutputDefinitionFile = ".\JobOutputDefinition.json"
New-AzStreamAnalyticsOutput `
  -ResourceGroupName $resourceGroup `
  -JobName $jobName `
  -File $jobOutputDefinitionFile `
  -Name $jobOutputName -Force 

  $jobTransformationName = "MyJobTransformation"
  $jobTransformationDefinitionFile = ".\JobTransformationDefinition.json"
  New-AzStreamAnalyticsTransformation `
    -ResourceGroupName $resourceGroup `
    -JobName $jobName `
    -File $jobTransformationDefinitionFile `
    -Name $jobTransformationName -Force