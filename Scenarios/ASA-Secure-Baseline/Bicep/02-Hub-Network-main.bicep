targetScope = 'subscription'

/******************************/
/*         PARAMETERS         */
/******************************/

@description('Bastion Name. Specify this value in the parameters.json file to override this default.')
param bastionName string = 'bastion-${namePrefix}'

//VNET Names - Override these in the parameters.json file to match your organization's naming conventions
@description('Name of the hub VNET. Specify this value in the parameters.json file to override this default.')
param hubVnetName string = 'vnet-${namePrefix}-${location}-HUB'

@description('Name of the resource group that has the hub VNET. Specify this value in the parameters.json file to override this default.')
param hubVnetRgName string = 'rg-${namePrefix}-HUB'

//Network Security Group Names - Override these in the parameters.json file to match your organization's naming conventions
@description('Network Security Group name for the Bastion subnet. Specify this value in the parameters.json file to override this default.')
param bastionNsgName string = 'bastion-nsg'

@description('IP CIDR Block for the Azure Firewall Subnet')
param azureFirewallSubnetPrefix string

@description('P CIDR Block for the Azure Bastion Subnet')
param bastionSubnetPrefix string

@description('IP CIDR Block for the Hub VNET')
param hubVnetAddressPrefix string

@description('Private IP address of the existing firewll.  Leave blank if you are deploying a new firewall specific to this landing zone.')
param firewallIp string = ''

@description('Boolean indicating whether or not to deploy the hub module. Set to false and override the hub module parameters if you already have one in place.')
param deployHub bool = true

@description('Boolean indicating whether or not to deploy the firewal. Set to false and override the fireawall module parameters if you already have one in place.')
param deployFirewall bool = true


@description('The Azure Region in which to deploy the Spring Apps Landing Zone Accelerator')
param location string

@description('The common prefix used when naming resources')
param namePrefix string

@description('Azure Resource Tags')
param tags object = {}

@description('Timestamp value used to group and uniquely identify a given deployment')
param timeStamp string = utcNow('yyyyMMddHHmm')

/******************************/
/*     RESOURCES & MODULES    */
/******************************/

module hub '02-Hub-Network/main.bicep' = if (deployHub) {
  name: '${timeStamp}-hub-vnet'
  params: {
    azureBastionSubnetPrefix: bastionSubnetPrefix
    azureFirewallSubnetPrefix: azureFirewallSubnetPrefix
    createFirewallSubnet: deployFirewall && firewallIp == '' ? true : false
    bastionName: bastionName
    bastionNsgName: bastionNsgName
    hubVnetAddressPrefix: hubVnetAddressPrefix
    hubVnetName: hubVnetName
    hubVnetRgName: hubVnetRgName
    location: location
    tags: tags
    timeStamp: timeStamp
  }
}
