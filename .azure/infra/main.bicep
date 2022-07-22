// ---------------------------------------------------------------------------
// Global parameters 
// ---------------------------------------------------------------------------

@minLength(1)
@maxLength(24)
@description('The name of your project')
param projectName string

@minLength(1)
@maxLength(10)
@description('The name of the environment')
param environment string = 'prod'

@description('The Azure region where all resources will be created')
param location string = 'eastus'

// ---------------------------------------------------------------------------

var commonTags = {
  project: projectName
  environment: environment
}

var uid = uniqueString(resourceGroup().id, projectName, environment, location)
var appInsightIntrumentationKey = reference(appInsights.id, appInsights.apiVersion).InstrumentationKey
var storageAccountConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'storage${uid}'
  location: location
  kind: 'StorageV2'
  tags: commonTags
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'insight-${projectName}-${environment}-${uid}'
  location: location
  kind: 'web'
  tags: commonTags
  properties: {
    Application_Type: 'web'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'asp-${projectName}-${environment}-${uid}'
  location: location
  kind: 'functionapp'
  tags: commonTags
  properties: {
    reserved: true
  }
  sku: {
    name: 'Y1'
  }
}

resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'func-${projectName}-${environment}-${uid}'
  location: location
  kind: 'functionapp,linux'
  tags: commonTags
  properties: {
    serverFarmId: appServicePlan.id
    clientAffinityEnabled: true
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
        {
          name: 'AzureWebJobsStorage'
          value: storageAccountConnectionString
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsightIntrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: reference(appInsights.id, appInsights.apiVersion).ConnectionString
        }
        {
          name: 'AzureWebJobsDisableHomepage'
          value: '1'
        }
      ]
      use32BitWorkerProcess: false
      linuxFxVersion: 'Node|16'
      cors: {
        allowedOrigins: [
          '*'
        ]
      }
    }
  }
}

output resourceGroupName string = resourceGroup().name
output functionAppName string = functionApp.name
output functionAppUrl string = functionApp.properties.defaultHostName
