param virtualMachines_WEB_01_name string = 'WEB-01'
param networkInterfaces_web_01251_name string = 'web-01251'
param publicIPAddresses_PIP_WEB_01_name string = 'PIP-WEB-01'
param virtualNetworks_VNET_CLOUDLAB_name string = 'VNET-CLOUDLAB'
param metricAlerts_Percentage_CPU_WEB_01_name string = 'Percentage CPU - WEB-01'
param metricAlerts_VM_Availability_WEB_01_name string = 'VM Availability - WEB-01'
param networkSecurityGroups_NSG_CLOUDLAB_APP_name string = 'NSG-CLOUDLAB-APP'
param metricAlerts_Network_In_Total_WEB_01_name string = 'Network In Total - WEB-01'
param actionGroups_RecommendedAlertRules_AG_1_name string = 'RecommendedAlertRules-AG-1'
param dataCollectionRules_msvmi_eastus_web_01_name string = 'msvmi-eastus-web-01'
param metricAlerts_Network_Out_Total_WEB_01_name string = 'Network Out Total - WEB-01'
param metricAlerts_Available_Memory_Bytes_WEB_01_name string = 'Available Memory Bytes - WEB-01'
param metricAlerts_OS_Disk_IOPS_Consumed_Percentage_WEB_01_name string = 'OS Disk IOPS Consumed Percentage - WEB-01'
param metricAlerts_Data_Disk_IOPS_Consumed_Percentage_WEB_01_name string = 'Data Disk IOPS Consumed Percentage - WEB-01'
param accounts_defaultazuremonitorworkspace_eus_externalid string = '/subscriptions/c48ba403-5ae5-47ae-8bec-0c2d4828740f/resourceGroups/defaultresourcegroup-eus/providers/microsoft.monitor/accounts/defaultazuremonitorworkspace-eus'

resource actionGroups_RecommendedAlertRules_AG_1_name_resource 'microsoft.insights/actionGroups@2024-10-01-preview' = {
  name: actionGroups_RecommendedAlertRules_AG_1_name
  location: 'Global'
  properties: {
    groupShortName: 'recalert1'
    enabled: true
    emailReceivers: [
      {
        name: 'Email0_-EmailAction-'
        emailAddress: 'datamaria805@outlook.com'
        useCommonAlertSchema: true
      }
    ]
    smsReceivers: []
    webhookReceivers: []
    eventHubReceivers: []
    itsmReceivers: []
    azureAppPushReceivers: []
    automationRunbookReceivers: []
    voiceReceivers: []
    logicAppReceivers: []
    azureFunctionReceivers: []
    armRoleReceivers: []
  }
}

resource dataCollectionRules_msvmi_eastus_web_01_name_resource 'Microsoft.Insights/dataCollectionRules@2024-03-11' = {
  name: dataCollectionRules_msvmi_eastus_web_01_name
  location: 'eastus'
  properties: {
    dataSources: {
      performanceCountersOTel: [
        {
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
          name: 'OtelDataSource'
        }
      ]
    }
    destinations: {
      monitoringAccounts: [
        {
          accountResourceId: accounts_defaultazuremonitorworkspace_eus_externalid
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
}

resource networkSecurityGroups_NSG_CLOUDLAB_APP_name_resource 'Microsoft.Network/networkSecurityGroups@2025-07-01' = {
  name: networkSecurityGroups_NSG_CLOUDLAB_APP_name
  location: 'eastus'
  properties: {
    securityRules: [
      {
        name: 'Allow-HTTP'
        id: networkSecurityGroups_NSG_CLOUDLAB_APP_name_Allow_HTTP.id
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'Allow-HTTPS'
        id: networkSecurityGroups_NSG_CLOUDLAB_APP_name_Allow_HTTPS.id
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource publicIPAddresses_PIP_WEB_01_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_PIP_WEB_01_name
  location: 'eastus'
  tags: {
    Environment: 'Lab'
    Project: 'CloudLab'
    CostCenter: 'LAB-001'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '40.114.74.214'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource virtualMachines_WEB_01_name_resource 'Microsoft.Compute/virtualMachines@2026-03-01' = {
  name: virtualMachines_WEB_01_name
  location: 'eastus'
  tags: {
    Environment: 'Lab'
    Project: 'CloudLab'
    CostCenter: 'LAB-001'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DC1ds_v3'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_WEB_01_name}_OsDisk_1_2ad4ddd1c47e45bc96d199c3d2171617'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_WEB_01_name}_OsDisk_1_2ad4ddd1c47e45bc96d199c3d2171617'
          )
        }
        deleteOption: 'Delete'
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_WEB_01_name
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
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'adminadmin'
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_web_01251_name_resource.id
          properties: {
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

resource networkSecurityGroups_NSG_CLOUDLAB_APP_name_Allow_HTTP 'Microsoft.Network/networkSecurityGroups/securityRules@2025-07-01' = {
  name: '${networkSecurityGroups_NSG_CLOUDLAB_APP_name}/Allow-HTTP'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '80'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_NSG_CLOUDLAB_APP_name_resource
  ]
}

resource networkSecurityGroups_NSG_CLOUDLAB_APP_name_Allow_HTTPS 'Microsoft.Network/networkSecurityGroups/securityRules@2025-07-01' = {
  name: '${networkSecurityGroups_NSG_CLOUDLAB_APP_name}/Allow-HTTPS'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '443'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 110
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_NSG_CLOUDLAB_APP_name_resource
  ]
}

resource virtualNetworks_VNET_CLOUDLAB_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_VNET_CLOUDLAB_name
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'snet-management'
        id: virtualNetworks_VNET_CLOUDLAB_name_snet_management.id
        properties: {
          addressPrefixes: [
            '10.10.1.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'snet-db'
        id: virtualNetworks_VNET_CLOUDLAB_name_snet_db.id
        properties: {
          addressPrefixes: [
            '10.10.3.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'snet-app'
        id: virtualNetworks_VNET_CLOUDLAB_name_snet_app.id
        properties: {
          addressPrefixes: [
            '10.10.2.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_NSG_CLOUDLAB_APP_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_VNET_CLOUDLAB_name_snet_db 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_VNET_CLOUDLAB_name}/snet-db'
  properties: {
    addressPrefixes: [
      '10.10.3.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_VNET_CLOUDLAB_name_resource
  ]
}

resource virtualNetworks_VNET_CLOUDLAB_name_snet_management 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_VNET_CLOUDLAB_name}/snet-management'
  properties: {
    addressPrefixes: [
      '10.10.1.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_VNET_CLOUDLAB_name_resource
  ]
}

resource metricAlerts_Available_Memory_Bytes_WEB_01_name_resource 'Microsoft.Insights/metricAlerts@2026-01-01' = {
  name: metricAlerts_Available_Memory_Bytes_WEB_01_name
  location: 'global'
  properties: {
    severity: 3
    enabled: true
    scopes: [
      virtualMachines_WEB_01_name_resource.id
    ]
    evaluationFrequency: 'PT5M'
    actions: [
      {
        actionGroupId: actionGroups_RecommendedAlertRules_AG_1_name_resource.id
      }
    ]
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          operator: 'LessThan'
          threshold: json('1000000000')
          name: 'Metric1'
          metricName: 'Available Memory Bytes'
          dimensions: []
          timeAggregation: 'Average'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
  }
}

resource metricAlerts_Data_Disk_IOPS_Consumed_Percentage_WEB_01_name_resource 'Microsoft.Insights/metricAlerts@2026-01-01' = {
  name: metricAlerts_Data_Disk_IOPS_Consumed_Percentage_WEB_01_name
  location: 'global'
  properties: {
    severity: 3
    enabled: true
    scopes: [
      virtualMachines_WEB_01_name_resource.id
    ]
    evaluationFrequency: 'PT5M'
    actions: [
      {
        actionGroupId: actionGroups_RecommendedAlertRules_AG_1_name_resource.id
      }
    ]
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          operator: 'GreaterThan'
          threshold: json('95')
          name: 'Metric1'
          metricName: 'Data Disk IOPS Consumed Percentage'
          dimensions: []
          timeAggregation: 'Average'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
  }
}

resource metricAlerts_Network_In_Total_WEB_01_name_resource 'Microsoft.Insights/metricAlerts@2026-01-01' = {
  name: metricAlerts_Network_In_Total_WEB_01_name
  location: 'global'
  properties: {
    severity: 3
    enabled: true
    scopes: [
      virtualMachines_WEB_01_name_resource.id
    ]
    evaluationFrequency: 'PT5M'
    actions: [
      {
        actionGroupId: actionGroups_RecommendedAlertRules_AG_1_name_resource.id
      }
    ]
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          operator: 'GreaterThan'
          threshold: json('500000000000')
          name: 'Metric1'
          metricName: 'Network In Total'
          dimensions: []
          timeAggregation: 'Total'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
  }
}

resource metricAlerts_Network_Out_Total_WEB_01_name_resource 'Microsoft.Insights/metricAlerts@2026-01-01' = {
  name: metricAlerts_Network_Out_Total_WEB_01_name
  location: 'global'
  properties: {
    severity: 3
    enabled: true
    scopes: [
      virtualMachines_WEB_01_name_resource.id
    ]
    evaluationFrequency: 'PT5M'
    actions: [
      {
        actionGroupId: actionGroups_RecommendedAlertRules_AG_1_name_resource.id
      }
    ]
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          operator: 'GreaterThan'
          threshold: json('200000000000')
          name: 'Metric1'
          metricName: 'Network Out Total'
          dimensions: []
          timeAggregation: 'Total'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
  }
}

resource metricAlerts_OS_Disk_IOPS_Consumed_Percentage_WEB_01_name_resource 'Microsoft.Insights/metricAlerts@2026-01-01' = {
  name: metricAlerts_OS_Disk_IOPS_Consumed_Percentage_WEB_01_name
  location: 'global'
  properties: {
    severity: 3
    enabled: true
    scopes: [
      virtualMachines_WEB_01_name_resource.id
    ]
    evaluationFrequency: 'PT5M'
    actions: [
      {
        actionGroupId: actionGroups_RecommendedAlertRules_AG_1_name_resource.id
      }
    ]
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          operator: 'GreaterThan'
          threshold: json('95')
          name: 'Metric1'
          metricName: 'OS Disk IOPS Consumed Percentage'
          dimensions: []
          timeAggregation: 'Average'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
  }
}

resource metricAlerts_Percentage_CPU_WEB_01_name_resource 'Microsoft.Insights/metricAlerts@2026-01-01' = {
  name: metricAlerts_Percentage_CPU_WEB_01_name
  location: 'global'
  properties: {
    severity: 3
    enabled: true
    scopes: [
      virtualMachines_WEB_01_name_resource.id
    ]
    evaluationFrequency: 'PT5M'
    actions: [
      {
        actionGroupId: actionGroups_RecommendedAlertRules_AG_1_name_resource.id
      }
    ]
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          operator: 'GreaterThan'
          threshold: json('80')
          name: 'Metric1'
          metricName: 'Percentage CPU'
          dimensions: []
          timeAggregation: 'Average'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
  }
}

resource metricAlerts_VM_Availability_WEB_01_name_resource 'Microsoft.Insights/metricAlerts@2026-01-01' = {
  name: metricAlerts_VM_Availability_WEB_01_name
  location: 'global'
  properties: {
    severity: 3
    enabled: true
    scopes: [
      virtualMachines_WEB_01_name_resource.id
    ]
    evaluationFrequency: 'PT5M'
    actions: [
      {
        actionGroupId: actionGroups_RecommendedAlertRules_AG_1_name_resource.id
      }
    ]
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          operator: 'LessThan'
          threshold: json('1')
          name: 'Metric1'
          metricName: 'VmAvailabilityMetric'
          dimensions: []
          timeAggregation: 'Average'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
  }
}

resource networkInterfaces_web_01251_name_resource 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: networkInterfaces_web_01251_name
  location: 'eastus'
  tags: {
    Environment: 'Lab'
    Project: 'CloudLab'
    CostCenter: 'LAB-001'
  }
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_web_01251_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '10.10.2.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_PIP_WEB_01_name_resource.id
            properties: {
              deleteOption: 'Detach'
            }
          }
          subnet: {
            id: virtualNetworks_VNET_CLOUDLAB_name_snet_app.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource virtualNetworks_VNET_CLOUDLAB_name_snet_app 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_VNET_CLOUDLAB_name}/snet-app'
  properties: {
    addressPrefixes: [
      '10.10.2.0/24'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_NSG_CLOUDLAB_APP_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_VNET_CLOUDLAB_name_resource
  ]
}
