# Overview

This demo uses two TeamCity build configurations:

1) BUILD_PACKAGE
   - Pull code from Git
   - Build and package files
   - Publish artifact

2) DEPLOY_TO_WINDOWS
   - Download artifact
   - Deploy to Windows server
   - Run smoke checks
