# Azure-Data-infrastructure-Automation
Provisioning of Azure Data Engineering infrastructure using terraform

# Azure Data Infrastructure Automation

## Overview

This project automates the provisioning of Azure Data Engineering infrastructure using Terraform. It sets up a comprehensive data pipeline environment on Azure, including resources like Azure Data Factory, Databricks, Synapse Analytics, Storage Accounts, and more.

The infrastructure is designed to support end-to-end data engineering processes, enabling data ingestion, storage, processing, and analytics. By automating the deployment, data engineers can focus on developing data solutions without worrying about the underlying infrastructure setup.

## Table of Contents

- [Architecture](#architecture)
- [Data Engineering Process](#data-engineering-process)
  - [Data Ingestion](#data-ingestion)
  - [Data Storage Layers](#data-storage-layers)
  - [Data Processing](#data-processing)
  - [Advanced Analytics](#advanced-analytics)
  - [Data Consumption](#data-consumption)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Clone the Repository](#clone-the-repository)
  - [Configure Variables](#configure-variables)
  - [Replace Placeholders](#replace-placeholders)
  - [Initialize Terraform](#initialize-terraform)
  - [Review the Execution Plan](#review-the-execution-plan)
  - [Apply the Configuration](#apply-the-configuration)
- [Resources Created](#resources-created)
- [Cleanup](#cleanup)
- [Notes](#notes)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Architecture

The infrastructure provisioned by this project includes:

- **Resource Group**
- **Azure Key Vault**
- **Azure Storage Account with Containers (Bronze, Silver, Gold)**
- **Azure Data Factory with Linked Services, Datasets, and Pipelines**
- **Azure Databricks Workspace with Notebooks and Cluster**
- **Azure Synapse Analytics Workspace with SQL Pool**


## Data Engineering Process

This section outlines the data engineering workflow enabled by the provisioned infrastructure.

### Data Ingestion

Data is ingested from an Azure SQL Database into Azure Data Lake Storage Gen2 using Azure Data Factory (ADF). The ADF pipeline (`copyPipeline`) copies data from the SQL database to the Data Lake in a scheduled or triggered manner.

- **Source**: Azure SQL Database
- **Destination**: Azure Data Lake Storage Gen2 (Bronze container)

**Key Components:**

- **Linked Services**: Define connections to data sources and sinks.
- **Datasets**: Represent data structures within data stores.
- **Activities**: Operations performed on data (e.g., Copy Activity).

### Data Storage Layers

The data lake is structured into three layers to support the **medallion architecture**:

1. **Bronze (Raw Data)**: Stores raw, unprocessed data as ingested from source systems.
2. **Silver (Cleaned Data)**: Contains data that has been cleaned, deduplicated, and conformed.
3. **Gold (Curated Data)**: Holds aggregated and business-level data ready for analytics and reporting.

This layered approach allows data engineers to manage data quality and apply transformations systematically.

### Data Processing

Azure Databricks is used for data processing and transformation tasks. Notebooks are developed and executed on Databricks clusters to read data from the Bronze layer, perform transformations, and write the results to the Silver and Gold layers.

- **Notebooks**: Interactive scripts developed in Python, Scala, SQL, or R.
- **Clusters**: Compute resources for executing notebooks. Configured with auto-scaling and auto-termination.

**Processing Steps:**

1. **Read Raw Data**: Load data from the Bronze layer.
2. **Data Cleaning**: Handle missing values, correct data types, remove duplicates.
3. **Transformation**: Apply business logic, calculations, and data enrichment.
4. **Write Processed Data**: Save the transformed data to the Silver and Gold layers.

### Advanced Analytics

Azure Synapse Analytics provides advanced analytics capabilities. Data from the Gold layer can be loaded into Synapse SQL pools for further analysis, reporting, or machine learning tasks.

- **Synapse Workspace**: Central hub for data analytics and collaboration.
- **SQL Pools**: Dedicated resources for processing large datasets with T-SQL.

**Capabilities:**

- **Data Warehousing**: Build scalable data warehouses.
- **Data Integration**: Orchestrate data movement and transformation.
- **Analytics**: Perform complex queries and integrate with BI tools.

### Data Consumption

Processed data can be consumed by various downstream applications or services, such as:

- **Business Intelligence Tools**: Power BI, Tableau for dashboards and reports.
- **Machine Learning Models**: Azure Machine Learning for predictive analytics.
- **Operational Systems**: APIs, web applications, or other services.

**Access Methods:**

- **Direct Query**: Connect directly to Synapse SQL pools or Data Lake Storage.
- **Data Export**: Extract data for use in external systems.
- **APIs**: Build APIs to serve data to applications.

### Workflow Summary

1. **Data Factory** copies data from Azure SQL Database to the Bronze container in Data Lake Storage.
2. **Databricks Notebooks** process the raw data, transforming it and storing it in the Silver and Gold containers.
3. **Synapse Analytics** connects to the Gold layer for advanced analytics and reporting.
4. **Data Consumption** by end-users or applications through various tools and services.


## Features

- **Automated Provisioning**: Uses Terraform scripts to automate the setup of Azure data infrastructure.
- **Data Pipeline Setup**: Establishes a data pipeline from Azure SQL Database to Azure Data Lake Storage Gen2.
- **Layered Data Lake Architecture**: Implements Bronze, Silver, and Gold layers for structured data processing.
- **Integration with Databricks**: Sets up Databricks notebooks and clusters for data processing.
- **Synapse Analytics**: Creates a Synapse workspace and SQL pool for advanced analytics.
- **Scalable and Extensible**: Infrastructure can be scaled and extended based on data engineering needs.

## Prerequisites

- **Azure Subscription**: With permissions to create resources.
- **Terraform**: Installed on your local machine (version >= 0.12).
- **Azure CLI**: For authentication and running scripts.
- **Databricks Token**: For accessing Databricks APIs.
- **Service Principal**: With appropriate permissions.
- **Git**: For cloning the repository.
- **Azure SQL Database**: Source database for data ingestion.
- **Notebooks**: Data transformation scripts to be uploaded to Databricks.

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/TEM-WONDER/Azure-Data-infrastructure-Automation.git
cd Azure-Data-infrastructure-Automation
```

### Configure Variables

Create a `terraform.tfvars` file or set environment variables for sensitive information:

```hcl
client_id     = "your-service-principal-client-id"
client_secret = "your-service-principal-client-secret"
tenant_id     = "your-tenant-id"
```

Alternatively, export them as environment variables:

```bash
export TF_VAR_client_id="your-service-principal-client-id"
export TF_VAR_client_secret="your-service-principal-client-secret"
export TF_VAR_tenant_id="your-tenant-id"
```

### Replace Placeholders

Update the Terraform scripts with your actual values:

- **Databricks Provider**: In `main.tf`, replace placeholders:

  ```hcl
  provider "databricks" {
    host  = "https://<databricks-instance>.azuredatabricks.net"
    token = "your-databricks-token"
  }
  ```

  - Replace `<databricks-instance>` with your Databricks workspace URL.
  - Replace `your-databricks-token` with your Databricks personal access token.

- **Azure Data Factory Linked Services**: Update connection strings and credentials.

  ```hcl
  resource "azurerm_data_factory_linked_service_sql_server" "sql_linked_service" {
    name              = "sqlLinkedService"
    data_factory_id   = azurerm_data_factory.adf.id

    connection_string = <<-EOF
      Server=tcp:<sql-server-name>.database.windows.net,1433;
      Initial Catalog=<database-name>;
      User ID=<username>;
      Password=<password>;
      Encrypt=True;
      Connection Timeout=30;
    EOF
  }
  ```

  - Replace `<sql-server-name>`, `<database-name>`, `<username>`, and `<password>` with your SQL database details.

- **Azure Role Assignments**: Replace `your_adf_principal_id` with your Data Factory's service principal ID.

- **Notebooks**: Update the `variable "notebooks"` section with the correct paths to your notebook files.

### Initialize Terraform

```bash
terraform init
```

### Review the Execution Plan

```bash
terraform plan
```

### Apply the Configuration

```bash
terraform apply
```

Type `yes` to confirm and start the deployment.

## Resources Created

- **Resource Group**: `rg-data-pipeline`
- **Key Vault**: `kv-datapipeline`
- **Storage Account**: `stgdatapipeline` with containers `bronze`, `silver`, and `gold`
- **Data Factory**: `adf-datapipeline` with linked services, datasets, and pipelines
- **Databricks Workspace**: `databricks-datapipeline` with notebooks and cluster
- **Synapse Workspace**: `synapse-datapipeline` with a SQL pool

## Cleanup

To destroy all the resources created by Terraform:

```bash
terraform destroy
```

Type `yes` to confirm the destruction.

## Notes

- **Sensitive Data**: Ensure that all sensitive information like passwords, tokens, and keys are stored securely and not hard-coded.
- **Azure CLI Authentication**: The `null_resource` for creating a view in Synapse uses Azure CLI commands. Make sure you're authenticated via Azure CLI.
- **Permissions**: The service principal must have the necessary permissions to create and manage resources.
- **Data Lake Storage**: The storage account is set up with hierarchical namespace (HNS) enabled for Azure Data Lake Storage Gen2 features.

## Troubleshooting

- **Authentication Errors**: Verify that your Azure CLI session is active and that your service principal credentials are correct.
- **Resource Quotas**: Check your Azure subscription limits to ensure you have sufficient quota.
- **Databricks Issues**: Ensure the Databricks workspace URL and token are correct and that you have access permissions.
- **Azure Data Factory**: If pipelines fail, check the linked service configurations and ensure network connectivity to the data sources.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request to contribute to this project.

## License
                    GNU GENERAL PUBLIC LICENSE
                       Version 3, 29 June 2007

---

## Appendices

### Best Practices for Data Engineers

- **Modularize Notebooks**: Break down processing tasks into modular notebooks for reusability and maintainability.
- **Parameterize Pipelines**: Use parameters in Data Factory pipelines to make them flexible and adaptable to different environments.
- **Monitor and Logging**: Implement monitoring for data pipelines and processing jobs using Azure Monitor and Log Analytics.
- **Security**: Use Azure Key Vault to store secrets and access keys securely. Implement role-based access control (RBAC).
- **Data Governance**: Apply data governance policies for data quality, lineage, and compliance using tools like Azure Purview.
- **Version Control**: Use Git repositories to version control your notebooks and pipeline configurations.

### Automation and CI/CD Integration

Integrate the Terraform scripts into a CI/CD pipeline to automate infrastructure deployments and updates.

- **Continuous Integration**: Set up pipelines to validate and test infrastructure code using tools like Azure DevOps or GitHub Actions.
- **Continuous Deployment**: Automate deployments to development, staging, and production environments.
- **Infrastructure as Code (IaC)**: Treat infrastructure configurations as code to ensure consistency and reproducibility.

### Scaling and Performance Optimization

- **Auto-scaling Clusters**: Configure Databricks clusters with auto-scaling to handle varying workloads efficiently.
- **Caching and Indexing**: Use caching mechanisms and create indexes in Synapse SQL pools to improve query performance.
- **Cost Management**: Monitor resource usage and optimize configurations to manage costs effectively.

### Additional Resources

- **Azure Data Factory Documentation**: [Link](https://docs.microsoft.com/en-us/azure/data-factory/)
- **Azure Databricks Documentation**: [Link](https://docs.microsoft.com/en-us/azure/databricks/)
- **Azure Synapse Analytics Documentation**: [Link](https://docs.microsoft.com/en-us/azure/synapse-analytics/)
- **Terraform Azure Provider Documentation**: [Link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

---

By following this guide, data engineers can efficiently set up a robust data infrastructure on Azure, enabling them to focus on data processing and analytics tasks. The automated deployment ensures consistency across environments and reduces the time spent on manual configurations.

If you have any questions or need further assistance, please feel free to reach out or open an issue in the repository.

Happy data engineering!