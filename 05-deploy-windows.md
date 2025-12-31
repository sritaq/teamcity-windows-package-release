# Deploy to Windows Server

DEPLOY_TO_WINDOWS build steps:
1. Download artifact from BUILD_PACKAGE
2. Extract ZIP to target directory
3. Validate deployment

Example PowerShell:
Expand-Archive app-package.zip C:\apps\demo -Force
