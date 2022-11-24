Install-Module -Name ImportExcel -Force


$xml = [xml](Get-Content .\Web.config)
$xml.configuration.appSettings.add | Select Key,Value| Export-Excel WebAppNameAppsettings.xlsx -WorksheetName AppName