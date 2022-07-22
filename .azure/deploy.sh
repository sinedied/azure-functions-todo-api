#!/usr/bin/env bash
##############################################################################
# Usage: ./deploy.sh <environment_name>
# Deploys the Azure resources for this project.
##############################################################################

set -e
cd $(dirname ${BASH_SOURCE[0]})
if [ -f ".settings" ]; then
  source .settings
fi

environment="${environment:-prod}"
environment="${1:-$environment}"

if [ ! -f ".${environment}.env" ]; then
  echo "Error: file '.${environment}.env' not found."
  exit 1
fi
source ".${environment}.env"

echo "Deploying environment '${environment}'..."

cd ../api
func azure functionapp fetch-app-settings ${function_app_name} --resource-group ${resource_group_name} --verbose
func azure functionapp publish ${function_app_name} --resource-group ${resource_group_name} --verbose

echo "Deployment complete for environment '${environment}'."

# cd .. && rm package.zip
# cd api && zip -r ../package.zip * && cd ..
# az functionapp deploy --resource-group ${resourceGroup} --name ${appName} --src-path package.zip --type zip --verbose
