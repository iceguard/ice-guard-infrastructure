Param
(
  [Parameter (Mandatory= $true)]
  [String] $rg,

  [Parameter (Mandatory= $true)]
  [String] $jobName
)

$servicePrincipalConnection = Get-AutomationConnection -Name 'AzureRunAsConnection'

$context = Add-AzAccount `
    -ServicePrincipal `
    -TenantId $servicePrincipalConnection.TenantId `
    -ApplicationId $servicePrincipalConnection.ApplicationId `
    -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint

Stop-AzStreamAnalyticsJob -ResourceGroupName $rg -Name $jobName