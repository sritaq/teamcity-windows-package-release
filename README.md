# TeamCity Windows Package Release 🚀

This project demonstrates a **TeamCity-based Release Engineering workflow**
where a package is built from Git, published as a TeamCity artifact,
and deployed to a **Windows server** using PowerShell.

## Flow
Git → TeamCity Build → Artifacts → TeamCity Deploy → Windows Server

## What this shows
- Artifact-driven releases
- Build & Deploy separation
- Windows-native PowerShell deployment
- Secure, auditable CI/CD practices

See docs/ for step-by-step explanation with screenshots.


---

## 🧠 Release Architecture (Windows)

1

- TeamCity Agent runs on Windows
- Package created as `.zip`
- Artifact stored centrally in TeamCity
- Deployment via **PowerShell**
- Target: Windows Server (VM / On-Prem / Cloud)

---

## ⚙️ TeamCity Build Configurations

### 🔹 Build Config 1: `BUILD_PACKAGE`

**Purpose:**  
Build and package application, publish artifact.

**Steps:**
1. Checkout code from Git
2. Run PowerShell build script
3. Produce package
4. Publish artifact

📸 *Screenshot:*  
`docs/images/tc-build-config.png`

---

### 🔹 Build Config 2: `DEPLOY_TO_WINDOWS`

**Purpose:**  
Fetch artifact and deploy to Windows server.

**Steps:**
1. Download artifact from BUILD_PACKAGE
2. Copy package to target folder
3. Extract package
4. Run smoke check

📸 *Screenshot:*  
`docs/images/tc-artifact-dependency.png`

---

## 📦 Build & Package (PowerShell)

### app/build.ps1

```powershell
$ErrorActionPreference = "Stop"

New-Item -ItemType Directory -Force -Path dist | Out-Null

Get-Date | Out-File dist\health.txt
Copy-Item sample-app.txt dist\sample-app.txt

Compress-Archive -Path dist\* -DestinationPath dist\app-package.zip -Force

Write-Host "Package created: dist\app-package.zip"


