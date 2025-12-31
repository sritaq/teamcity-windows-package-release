$ErrorActionPreference = "Stop"

New-Item -ItemType Directory -Force -Path dist | Out-Null

Get-Date | Out-File dist\health.txt
Copy-Item sample-app.txt dist\sample-app.txt

Compress-Archive -Path dist\* -DestinationPath dist\app-package.zip -Force

Write-Host "Package created: dist\app-package.zip"
