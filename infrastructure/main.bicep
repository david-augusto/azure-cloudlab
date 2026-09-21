targetScope = 'resourceGroup'

@description('Azure region for all CloudLab resources.')
param location string = resourceGroup().location

@description('Virtual machine name.')
param vmName string = 'WEB-01'

@description('VM size. Keep Standard_DC1ds_v3 to match the original lab, or change it if the target subscription/region does not offer it.')
param vmSize string = 'Standard_DC1ds_v3'

@description('Local administrator username for the Windows VM.')
param adminUsername string = 'azureadmin'

@description('Local administrator password. Never commit the value to GitHub.')
@secure()
@minLength(12)
param adminPassword string

@description('Email address that receives CloudLab metric alerts.')
param alertEmail string

@description('Public IP resource name.')
param publicIpName string = 'PIP-WEB-01'

@description('Virtual network name.')
param vnetName string = 'VNET-CLOUDLAB'

@description('Application NSG name.')
param nsgName string = 'NSG-CLOUDLAB-APP'

@description('Network interface name.')
param nicName string = 'web-01251'

@description('Azure Monitor workspace name. This is created inside the CloudLab resource group instead of using the automatically-created default workspace resource group.')
param monitorWorkspaceName string = 'AMW-CLOUDLAB'

@description('Data Collection Rule name.')
param dcrName string = 'dcr-cloudlab-vm'

@description('Action Group name.')
param actionGroupName string = 'CloudLab-Alerts'

var tags = {
  Environment: 'Lab'
  Project: 'CloudLab'
  CostCenter: 'LAB-001'
  Owner: 'David'
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2025-07-01' = {
  name: nsgName
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'Allow-HTTP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow-HTTPS'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-management'
        properties: {
          addressPrefixes: [
            '10.10.1.0/24'
          ]
          defaultOutboundAccess: false
        }
      }
      {
        name: 'snet-app'
        properties: {
          addressPrefixes: [
            '10.10.2.0/24'
          ]
          networkSecurityGroup: {
            id: nsg.id
          }
          defaultOutboundAccess: false
        }
      }
      {
        name: 'snet-db'
        properties: {
          addressPrefixes: [
            '10.10.3.0/24'
          ]
          defaultOutboundAccess: false
        }
      }
    ]
  }
}

resource publicIp 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIpName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: nicName
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp.id
            properties: {
              deleteOption: 'Detach'
            }
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, 'snet-app')
          }
          primary: true
        }
      }
    ]
  }
  dependsOn: [
    vnet
  ]
}

resource vm 'Microsoft.Compute/virtualMachines@2026-03-01' = {
  name: vmName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        deleteOption: 'Delete'
      }
      dataDisks: []
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByPlatform'
          automaticByPlatformSettings: {
            rebootSetting: 'IfRequired'
          }
          assessmentMode: 'ImageDefault'
          enableHotpatching: true
        }
      }
    }
    securityProfile: {
      securityType: 'TrustedLaunch'
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
          properties: {
            primary: true
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource entraLogin 'Microsoft.Compute/virtualMachines/extensions@2024-11-01' = {
  name: '${vm.name}/AADLogin'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.ActiveDirectory'
    type: 'AADLoginForWindows'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
  dependsOn: [
    vm
  ]
}

resource monitorWorkspace 'Microsoft.Monitor/accounts@2025-10-03' = {
  name: monitorWorkspaceName
  location: location
  tags: tags
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}

resource dcr 'Microsoft.Insights/dataCollectionRules@2024-03-11' = {
  name: dcrName
  location: location
  tags: tags
  properties: {
    dataSources: {
      performanceCountersOTel: [
        {
          name: 'OtelDataSource'
          streams: [
            'Microsoft-OtelPerfMetrics'
          ]
          samplingFrequencyInSeconds: 60
          counterSpecifiers: [
            'system.filesystem.usage'
            'system.disk.io'
            'system.disk.operation_time'
            'system.disk.operations'
            'system.memory.usage'
            'system.network.io'
            'system.cpu.time'
            'system.network.dropped'
            'system.network.errors'
            'system.uptime'
          ]
        }
      ]
    }
    destinations: {
      monitoringAccounts: [
        {
          accountResourceId: monitorWorkspace.id
          name: 'MonitoringAccountDestination'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-OtelPerfMetrics'
        ]
        destinations: [
          'MonitoringAccountDestination'
        ]
      }
    ]
  }
  dependsOn: [
    monitorWorkspace
  ]
}

resource azureMonitorAgent 'Microsoft.Compute/virtualMachines/extensions@2024-11-01' = {
  name: '${vm.name}/AzureMonitorWindowsAgent'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Monitor'
    type: 'AzureMonitorWindowsAgent'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: true
  }
  dependsOn: [
    vm
  ]
}

resource dcrAssociation 'Microsoft.Insights/dataCollectionRuleAssociations@2024-03-11' = {
  name: 'CloudLab-DCR-Association'
  scope: vm
  properties: {
    description: 'Associates the CloudLab VM with the CloudLab Azure Monitor data collection rule.'
    dataCollectionRuleId: dcr.id
  }
  dependsOn: [
    dcr
    azureMonitorAgent
  ]
}

resource actionGroup 'Microsoft.Insights/actionGroups@2024-10-01-preview' = {
  name: actionGroupName
  location: 'Global'
  tags: tags
  properties: {
    groupShortName: 'cloudlab'
    enabled: true
    emailReceivers: [
      {
        name: 'CloudLabEmail'
        emailAddress: alertEmail
        useCommonAlertSchema: true
      }
    ]
  }
}

resource alertCpu 'Microsoft.Insights/metricAlerts@2026-01-01' = {
  name: 'Percentage CPU - WEB-01'
  location: 'global'
  tags: tags
  properties: {
    severity: 3
    enabled: true
    scopes: [
      vm.id
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
    actions: [
      {
        actionGroupId: actionGroup.id
      }
    ]
    criteria: {
      allOf: [
        {
          name: 'CPUHigh'
          criterionType: 'StaticThresholdCriterion'
          metricName: 'Percentage CPU'
          operator: 'GreaterThan'
          threshold: 80
          timeAggregation: 'Average'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
  }
}

resource alertAvailability 'Microsoft.Insights/metricAlerts@2026-01-01' = {
  name: 'VM Availability - WEB-01'
  location: 'global'
  tags: tags
  properties: {
    severity: 3
    enabled: true
    scopes: [
      vm.id
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
    actions: [
      {
        actionGroupId: actionGroup.id
      }
    ]
    criteria: {
      allOf: [
        {
          name: 'VMAvailability'
          criterionType: 'StaticThresholdCriterion'
          metricName: 'VmAvailabilityMetric'
          operator: 'LessThan'
          threshold: 1
          timeAggregation: 'Average'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
  }
}

resource alertMemory 'Microsoft.Insights/metricAlerts@2026-01-01' = {
  name: 'Available Memory Bytes - WEB-01'
  location: 'global'
  tags: tags
  properties: {
    severity: 3
    enabled: true
    scopes: [
      vm.id
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
    actions: [
      {
        actionGroupId: actionGroup.id
      }
    ]
    criteria: {
      allOf: [
        {
          name: 'LowAvailableMemory'
          criterionType: 'StaticThresholdCriterion'
          metricName: 'Available Memory Bytes'
          operator: 'LessThan'
          threshold: 1000000000
          timeAggregation: 'Average'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
  }
}

resource alertOsDisk 'Microsoft.Insights/metricAlerts@2026-01-01' = {
  name: 'OS Disk IOPS Consumed Percentage - WEB-01'
  location: 'global'
  tags: tags
  properties: {
    severity: 3
    enabled: true
    scopes: [
      vm.id
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
    actions: [
      {
        actionGroupId: actionGroup.id
      }
    ]
    criteria: {
      allOf: [
        {
          name: 'OSDiskIOPSHigh'
          criterionType: 'StaticThresholdCriterion'
          metricName: 'OS Disk IOPS Consumed Percentage'
          operator: 'GreaterThan'
          threshold: 95
          timeAggregation: 'Average'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
  }
}

resource alertDataDisk 'Microsoft.Insights/metricAlerts@2026-01-01' = {
  name: 'Data Disk IOPS Consumed Percentage - WEB-01'
  location: 'global'
  tags: tags
  properties: {
    severity: 3
    enabled: true
    scopes: [
      vm.id
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
    actions: [
      {
        actionGroupId: actionGroup.id
      }
    ]
    criteria: {
      allOf: [
        {
          name: 'DataDiskIOPSHigh'
          criterionType: 'StaticThresholdCriterion'
          metricName: 'Data Disk IOPS Consumed Percentage'
          operator: 'GreaterThan'
          threshold: 95
          timeAggregation: 'Average'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
  }
}

resource alertNetworkIn 'Microsoft.Insights/metricAlerts@2026-01-01' = {
  name: 'Network In Total - WEB-01'
  location: 'global'
  tags: tags
  properties: {
    severity: 3
    enabled: true
    scopes: [
      vm.id
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
    actions: [
      {
        actionGroupId: actionGroup.id
      }
    ]
    criteria: {
      allOf: [
        {
          name: 'NetworkInHigh'
          criterionType: 'StaticThresholdCriterion'
          metricName: 'Network In Total'
          operator: 'GreaterThan'
          threshold: 500000000000
          timeAggregation: 'Total'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
  }
}

resource alertNetworkOut 'Microsoft.Insights/metricAlerts@2026-01-01' = {
  name: 'Network Out Total - WEB-01'
  location: 'global'
  tags: tags
  properties: {
    severity: 3
    enabled: true
    scopes: [
      vm.id
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
    actions: [
      {
        actionGroupId: actionGroup.id
      }
    ]
    criteria: {
      allOf: [
        {
          name: 'NetworkOutHigh'
          criterionType: 'StaticThresholdCriterion'
          metricName: 'Network Out Total'
          operator: 'GreaterThan'
          threshold: 200000000000
          timeAggregation: 'Total'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
  }
}
