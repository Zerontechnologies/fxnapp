{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "sqlAdministratorLogin": {
      "type": "string",
      "defaultValue": "sqladminu",
      "metadata": {
        "description": "The administrator username of the SQL Server."
      }
    },
    "sqlAdministratorLoginPassword": {
      "type": "securestring",
      "defaultValue": "@!234getaXlease",
      "metadata": {
        "description": "The administrator password of the SQL Server."
      }
    },
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]",
      "metadata": {
        "description": "Location for all resources."
      }
    },
    "sqlServerName": {
        "type": "string",
        "defaultValue": "uchdnserver",
        "metadata": {
            "description": "Sql server name"
        }
    },
    "databaseName": {
        "type": "string",
        "defaultValue": "uchsdb",
        "metadata": {
            "description": "Database Name"
        }
    }
  },
  "variables": {
    "databaseEdition": "Basic",
    "databaseCollation": "SQL_Latin1_General_CP1_CI_AS"
  },
  "resources": [
    {
      "name": "[parameters('sqlServerName')]",
      "type": "Microsoft.Sql/servers",
      "apiVersion": "2020-02-02-preview",
      "location": "[parameters('location')]",
      "tags": {
        "displayName": "SqlServer"
      },
      "properties": {
        "administratorLogin": "[parameters('sqlAdministratorLogin')]",
        "administratorLoginPassword": "[parameters('sqlAdministratorLoginPassword')]",
        "version": "12.0"
      },
      "resources": [
        {
          "name": "[parameters('databaseName')]",
          "type": "databases",
          "apiVersion": "2020-02-02-preview",
          "location": "[parameters('location')]",
          "tags": {
            "displayName": "Database"
          },
          "properties": {
            "edition": "[variables('databaseEdition')]",
            "collation": "[variables('databaseCollation')]"
          },
          "dependsOn": [
            "[parameters('sqlServerName')]"
          ]
        },
        {
          "name": "AllowAllMicrosoftAzureIps",
          "type": "firewallrules",
          "apiVersion": "2020-02-02-preview",
          "location": "[parameters('location')]",
          "properties": {
            "endIpAddress": "0.0.0.0",
            "startIpAddress": "0.0.0.0"
          },
          "dependsOn": [
            "[parameters('sqlServerName')]"
          ]
        }
      ]
    }
  ],
  "outputs": {
    "sqlServerFqdn": {
      "type": "string",
      "value": "[reference(resourceId('Microsoft.Sql/servers/', parameters('sqlServerName'))).fullyQualifiedDomainName]"
    },
    "databaseName": {
      "type": "string",
      "value": "[parameters('databaseName')]"
    }
  }
}
