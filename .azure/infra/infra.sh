#!/bin/bash
##############################################################################
# Usage: ./infra.sh <up|down> <project_name> [environment_name] [location]
# Creates or deletes the Azure infrastructure for this project.
##############################################################################

set -e
set -u

project_name=${2}
environment="${3:-prod}"
location="${4:-eastus2}"

showUsage() {
  script_name="$(basename "$0")"
  echo "Usage: ./$script_name <up|down|cancel> <project_name> [environment_name] [location]"
  echo "Creates or deletes the Azure infrastructure for this project."
  echo
}

if [ -z "$project_name" ]; then
  showUsage
  echo "Error: project name is required."
  exit 1
elif [ "$1" == "up" ]; then
  # echo "Retrieving current client ID..."
  # clientId=$(az ad signed-in-user show --query "id" --output tsv)
  echo "Preparing environment '${environment}' of project '${project_name}'..."
  resource_group_name=rg-${project_name}-${environment}
  az group create \
    --name ${resource_group_name} \
    --location ${location} \
    --output none
  echo "Resource group '${resource_group_name}' ready."
  # outputs=$( \
    az deployment group create \
    --resource-group ${resource_group_name} \
    --template-file main.bicep \
    --name "deployment-${project_name}-${environment}-${location}" \
    --parameters project_name=${project_name} \
        environment=${environment} \
        location=${location} \
    --query properties.outputs \
    --mode Complete \
    --verbose
  # )
  # echo $outputs
  echo "Environment '${environment}' of project '${project_name}' ready."
elif [ "$1" == "down" ]; then
  echo "Deleting environment '${environment}' of project '${project_name}'..."
  az group delete --yes --name "rg-${project_name}-${environment}"
  echo "Environment '${environment}' of project '${project_name}' deleted."
elif [ "$1" == "cancel" ]; then
  echo "Cancelling preparation of environment '${environment}' of project '${project_name}'..."
  az deployment group cancel \
    --resource-group ${resource_group_name} \
    --name "deployment-${project_name}-${environment}-${location}"
    --verbose
  echo "Preparation of '${environment}' of project '${project_name}' cancelled."
else
  showUsage
fi
