#!/bin/bash
##############################################################################
# Usage: ./setup.sh [--skip-login|--terminate]
# Setup the current GitHub repo for deploying on Azure.
##############################################################################

set -e

showUsage() {
  script_name="$(basename "$0")"
  echo "Usage: ./$script_name"
  echo "Setup the current GitHub repo for deploying on Azure."
  echo
  echo "Options:"
  echo "  -s, --skip-login    Skip Azure and GitHub login steps"
  echo "  -t, --terminate     Remove current setup and delete deployed resources"
  echo
}

skip_login=false
terminate=false
args=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -s|--skip-login)
      skip_login=true
      shift
      ;;
    -t|--terminate)
      terminate=true
      shift
      ;;
    --help)
      showUsage
      exit 0
      ;;
    -*|--*)
      showUsage
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      # save positional arg
      args+=("$1")
      shift
      ;;
  esac
done

# restore positional args
set -- "${args[@]}"

if ! command -v az &> /dev/null; then
  echo "Azure CLI not found."
  echo "See https://aka.ms/tools/azure-cli for installation instructions."
  exit 1
fi

if ! command -v gh &> /dev/null; then
  echo "GitHub CLI not found."
  echo "See https://cli.github.com for installation instructions."
  exit 1
fi

if [ "$skip_login" = false ]; then
  echo "Loggging in to Azure..."
  az login
  echo "Logging in to GitHub..."
  gh login
  echo "Login successful."
fi

if [ "$terminate" = true ]; then
  echo "Deleting current setup..."
  infra/infra.sh down todo-api
  echo "Retrieving GitHub repository URL..."
  remote_repo=$(git config --get remote.origin.url)
  gh secret delete AZURE_CREDENTIALS -R $remote_repo
  echo "Setup deleted."
else
  echo "Retrieving Azure subscription..."
  subscription_id=$(az account show --query id --output tsv --only-show-errors)
  echo "Creating Azure service principal..."
  service_principal=$(az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$subscription_id" --sdk-auth --only-show-errors)
  echo "Retrieving GitHub repository URL..."
  remote_repo=$(git config --get remote.origin.url)
  echo "Setting up GitHub repository secrets..."
  gh secret set AZURE_CREDENTIALS -b"$service_principal" -R $remote_repo
  echo "Triggering Azure deployment..."
  gh workflow run deploy.yml
  echo "Setup success!"
fi
