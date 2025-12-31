
# 🪟🚀 TeamCity → Windows Server Package Release  
### (Artifact-driven Release Engineering Demo)

**Git → Build → Package → Artifact → Deploy → Windows Server**  
Enterprise-style, **auditable & repeatable** release workflow.

<img width="1064" height="485" alt="17671925580491858982997763960867" src="https://github.com/user-attachments/assets/cb6bf46b-d2d8-49fc-a9ee-4e22dcbadcc7" />


---

## 🎯 What this project demonstrates

- TeamCity CI/CD fundamentals
- Artifact-based release engineering
- Separation of **Build** and **Deploy**
- Windows-native deployment using **PowerShell**
- Secure parameters (no secrets in Git)
- Real-world Release Engineer workflow

---

## 🧭 High-Level Architecture

```text
Git Commit
   ↓
TeamCity BUILD_PACKAGE
   ↓ (Artifacts)
TeamCity DEPLOY_TO_WINDOWS
   ↓
Windows Server (C:\apps\demo)

📸 TeamCity UI – Reference Images (Internet Links)
These are public TeamCity documentation images.
They work without storing images in the repo.
🔹 Create Build Configuration
<img width="894" height="638" alt="17671921471658683782862183692520" src="https://github.com/user-attachments/assets/229d8d9a-8148-48a9-bf98-045c7cfc2be4" />

🔹 Configure Artifact Paths
![17671921899123667561310522304536](https://github.com/user-attachments/assets/354caf48-7136-47f5-bed4-23927883a41a)

🔹 Add Artifact Dependency (Build → Deploy)
<img width="918" height="426" alt="17671922075617069594800003914613" src="https://github.com/user-attachments/assets/554b46da-4e3e-4def-a9ac-0eac26134446" />

🔹 Artifact Dependency Dialog
<img width="1064" height="485" alt="17671922315321743640982518632881" src="https://github.com/user-attachments/assets/99e6d0e8-bff3-4c31-87ec-23bf166d0b59" />

🧱 Repository Structure
teamcity-windows-package-release/
├─ README.md
├─ app/
│  ├─ build.ps1
│  └─ sample-app.txt
├─ scripts/
│  ├─ release.ps1        # one-click build + deploy
│  └─ deploy-remote.ps1 # Windows deployment via WinRM
└─ docs/
   └─ runbook.md


🔹 BUILD_PACKAGE (TeamCity)
Step 1: Create Build Configuration
Name: BUILD_PACKAGE
Attach Git VCS Root
Branch: main

Step 2: Build Step (PowerShell)
Runner Type: PowerShell
Script file:
app\build.ps1


Step 3: Publish Artifact
Artifact paths:
dist\app-package.zip


🔹 DEPLOY_TO_WINDOWS (TeamCity)
Step 4: Create Deploy Build
Name: DEPLOY_TO_WINDOWS

Step 5: Add Artifact Dependency
Depend on: BUILD_PACKAGE
Get artifacts from: Latest successful build
Artifact rules:
dist\app-package.zip => .

Step 6: Deploy Step (PowerShell)
Runner Type: PowerShell
Script file:
scripts\deploy-remote.ps1


🔐 TeamCity Parameters (Secure)
Add these parameters in TeamCity (NOT in Git):
env.DEPLOY_HOST → winserver01
env.DEPLOY_PATH → C:\apps\demo
env.DEPLOY_USER → DOMAIN\deployuser
secure:DEPLOY_PASS → password
✔ Secure
✔ Audit-friendly
✔ Enterprise standard


🧰 One-Click Release Script (Build + Deploy)
Instead of separate steps, you can run one script.
PowerShell Runner
Script file:
scripts\release.ps1

Arguments:
-DeployHost "%env.DEPLOY_HOST%" -DeployPath "%env.DEPLOY_PATH%" -DeployUser "%env.DEPLOY_USER%" -DeployPass "%secure:DEPLOY_PASS%"

This script:
Builds the package
Creates ZIP artifact
Deploys to Windows server
Runs smoke check
📦 build.ps1 (Package Creation)

$ErrorActionPreference = "Stop"

New-Item -ItemType Directory -Force -Path dist | Out-Null

Get-Date | Out-File dist\health.txt
Copy-Item sample-app.txt dist\sample-app.txt

Compress-Archive -Path dist\* -DestinationPath dist\app-package.zip -Force

Write-Host "Package created: dist\app-package.zip"

🚀 deploy-remote.ps1 (Windows Deployment)

param(
  [string]$DeployHost,
  [string]$DeployPath,
  [string]$DeployUser,
  [string]$DeployPass
)

$sec = ConvertTo-SecureString $DeployPass -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($DeployUser, $sec)

$session = New-PSSession -ComputerName $DeployHost -Credential $cred

Copy-Item app-package.zip -ToSession $session -Destination "$DeployPath\app-package.zip" -Force

Invoke-Command -Session $session -ScriptBlock {
  Expand-Archive "C:\apps\demo\app-package.zip" "C:\apps\demo" -Force
  Get-Content "C:\apps\demo\health.txt"
}

Remove-PSSession $session
📘 Release Runbook (docs/runbook.md)
Pre-release checks
Deployment verification
Common failure handling
Rollback guidance
