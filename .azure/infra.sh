#!/usr/bin/env bash
##############################################################################
# Usage: ./infra.sh <up|down> <project_name> [environment_name] [location]
# Creates or deletes the Azure infrastructure for this project.
##############################################################################

set -e
cd $(dirname ${BASH_SOURCE[0]})
if [ -f ".settings" ]; then
  source .settings
fi

subcommand="${1}"
project_name="${2:-$project_name}"
environment="${environment:-prod}"
environment="${3:-$environment}"
location="${location:-eastus2}"
location="${4:-$location}"

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
fi

if [ "${subcommand}" == "up" ]; then
  # echo "Retrieving current client ID..."
  # clientId=$(az ad signed-in-user show --query "id" --output tsv)
  echo "Preparing environment '${environment}' of project '${project_name}'..."
  resource_group_name=rg-${project_name}-${environment}
  az group create \
    --name ${resource_group_name} \
    --location ${location} \
    --output none
  echo "Resource group '${resource_group_name}' ready."
  outputs=$( \
    az deployment group create \
    --resource-group ${resource_group_name} \
    --template-file infra/main.bicep \
    --name "deployment-${project_name}-${environment}-${location}" \
    --parameters projectName=${project_name} \
        environment=${environment} \
        location=${location} \
    --query properties.outputs \
    --mode Complete \
    --verbose
  )
  echo $outputs
  echo "Environment '${environment}' of project '${project_name}' ready."
elif [ "${subcommand}" == "down" ]; then
  echo "Deleting environment '${environment}' of project '${project_name}'..."
  az group delete --yes --name "rg-${project_name}-${environment}"
  echo "Environment '${environment}' of project '${project_name}' deleted."
elif [ "${subcommand}" == "cancel" ]; then
  echo "Cancelling preparation of environment '${environment}' of project '${project_name}'..."
  az deployment group cancel \
    --resource-group ${resource_group_name} \
    --name "deployment-${project_name}-${environment}-${location}"
    --verbose
  echo "Preparation of '${environment}' of project '${project_name}' cancelled."
else
  showUsage
fi
