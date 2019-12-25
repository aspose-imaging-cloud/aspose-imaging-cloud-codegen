param([string]$pathToSdk)

$lines = Get-Content -encoding UTF8 $pathToSdk\lib\api.ts 
$jsonSpec = (Invoke-WebRequest https://api-qa.aspose.cloud/v3.0/imaging/swagger/sdkspec | Select-Object -Property Content).content | Out-String | ConvertFrom-Json

# Generate Doc

Import-Module ./PSNodejsCodeGenerator.psm1
Import-Module ./PSCoreCodeGenerator.psm1

Update-Doc