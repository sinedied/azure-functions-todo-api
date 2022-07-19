#!/bin/bash
##############################################################################
# Usage: ./deploy.sh
# Deploys the Azure resources for this project.
##############################################################################

set -e
set -u

resource_group=rg-todo-api-prod
app_name=func-todo-api-prod-pavmt75fjq3kk

# cd .. && rm package.zip
# cd api && zip -r ../package.zip * && cd ..
# az functionapp deploy --resource-group ${resourceGroup} --name ${appName} --src-path package.zip --type zip --verbose

cd ../api
func azure functionapp publish ${app_name} --resource-group ${resource_group} --verbose
