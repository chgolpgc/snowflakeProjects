/* Let's create an storage integration in Snowflake so we can connect to files in our ADLS/Blob storage.
The steps to follow are:

1 - Create a Storage Integration via CREATE STORAGE INTEGRATION <name>. Get tenant ID value from Azure Active Directory.
2 - Describe Storage integration (DESC STORAGE INTEGRATION <name>) and click on the link for "AZURE_CONSENT_URL".
3 - Grant Read/Contributor role to the app created in Azure. The app name will be the value for AZURE_MULTI_TENANT_APP_NAME
4 - Create a file format for your files
5 - Create a stage via CREATE STAGE <name> and specify required values.
 -> Important note: even if you are using ADLSg2 instead of a Blob storage, you need to use "blob.core" in URL - not "dfs.core"
*/

CREATE STORAGE INTEGRATION AzureADLSIntegration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = '<tenant_id>'
  STORAGE_ALLOWED_LOCATIONS = ('azure://<storageAccount>.blob.core.windows.net/<container>/');

DESC STORAGE INTEGRATION AzureADLSIntegration;
  

CREATE OR REPLACE FILE FORMAT FF_CSV
TYPE = 'CSV'
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
NULL_IF = ('NULL', 'null');


CREATE STAGE ADLS_Stage
  STORAGE_INTEGRATION = AzureADLSIntegration
  URL = 'azure://<storageAccount>.blob.core.windows.net/<container>/' 
  FILE_FORMAT = FF_CSV

