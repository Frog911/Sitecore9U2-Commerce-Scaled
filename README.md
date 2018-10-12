# Objective:
Deploy Sitecore 9 Commerce Update 2 in scaled enviornment (IaaS or on prem) irrespective of XP topology as long as you have required access to the servers. This script will allow to deploy each of the commerce services independently of each other and on seperate servers. 

# Prerequisite:
Sitecore 9 is up and running with SQL Server and Solr

A user with a name ‘CSFndRuntimeUser’ is created on all the servers under ‘Local Users and Group’. While creating a user provide any password you want. 

# Hosting Environment Requirement:
Operating System: Windows Server 2016

.NET Framework: .NET Framework 4.6.2 Developer Pack (including available updates) , ASP.NET MVC 4 or later, 
Windows Server Hosting 2.0.0 , OData 7.2.0

Database: Microsoft SQL Server 2016 SP1

Web server: IIS 10.0 or IIS 8.5 (the version supported by your operating system) , Microsoft Web Deploy 3.6 , URL Rewriter

Deployment: PowerShell 5.1 or later

Solr Server: Solr 6.6.2 on HTTPS

Sitecore software: Sitecore Experience Platform 9.0 Update-2

Microsoft Visual C++ Redistributable: https://www.microsoft.com/en-us/download/details.aspx?id=53840

ASP.NET Core 2.0 .NET Core: https://www.microsoft.com/net/download/dotnet-core/runtime-2.0.7

SitecoreFundamentals: https://sitecore.myget.org/feed/sc-powershell/package/nuget/SitecoreFundamentals

SitecoreInstallFramework: https://sitecore.myget.org/feed/sc-powershell/package/nuget/SitecoreInstallFramework

IIS and .NET Core is installed on all the servers where we are hosting following roles:

•	BizFx

•	Identity

•	Authoring

•	Minion

•	Shops 

•	Ops

**Working on updating and testing the scripts where XConnect is deployed on separate server.

# Overview:
Common PowerShell script is used to deploy all the roles and required packages. Just provide the Role to be deployed in the PowerShell script and run it on a specific server. The PowerShell script will create the website, modify the required configuration, assign the required certificate and create the host entry.

# Recommendation:

Follow the steps mentioned in ‘Setting Up the Scripts’ on any one server and later copy it on all the servers to reduce the overall effort.

# Setting Up the Scripts:

•	Download Sitecore Experience Commerce (Sitecore XC) ‘On Premise’ package from https://dev.sitecore.net/Downloads/Sitecore_Commerce/90/Sitecore_Experience_Commerce_90_Update2.aspx

# Step 0

Unzip the package. For rest of the documentation I assume you have unzipped it on ‘C:\Deploy’ Folder.

•	Unzip following files inside c:\deploy folder

   o	Sitecore.Commerce.Engine.SDK.x.x.xxxx.zip

  o	Sitecore.BizFX.x.x.xxx.zip
    
•	Download assets zip and SIF.Sitecore.Commerce.1.2.14 files from github, place and unzip it in ‘C:\Deploy’ folder

•	Download Sitecore Experience Accelerator package (zip file) from https://dev.sitecore.net/Downloads/Sitecore_Experience_Accelerator.aspx and plavce the zip file in assets folder

•	Open "C:\deploy\SIF.Sitecore.Commerce.1.2.14\Deploy-Sitecore-Commerce.ps1" in Powershell or your choice of editor and update following parameters as per your implementation:

   o	[string]$SiteName = [Sitecore website name],
   
   o	[string]$SiteHostHeaderName = [Storefront name],	
   
   o	[string]$SqlDbPrefix = [Prefix used for databade tables like xp05],
   
   o	[string]$CommerceSearchProvider = [Search server used like SOLR]
      
   o	[string]$RoleToBeDeployed = "" #Roles can be Identity or BizFx or Ops or Authoring or Minions or Shops or Solr or CM or CD
      
   o	$SifPath = "" #path till \Configuration folder (e.g C:\deploy\SIF.Sitecore.Commerce.1.2.14)
   
   o	$CommerceInstallDir = "" #path to install commerce sites (e.g C:\inetpub\wwwroot)
   
   o	XConnectInstallDir = [Webroot path of xConnect]
   
   o	CommerceServicesDbServer = DB Server IP Address or name    
   
   o	CommerceServicesDbName = [Shared env. DB name.]
   
   o	CommerceServicesGlobalDbName = [Global DB name]		
   
   o	SitecoreDbServer = [DB Server IP Address or name]    
   
   o	SitecoreCoreDbName = [Sitecore Core DB name]
   
   o	SitecoreUsername = [Sitecore login username]
   
   o	SitecoreUserPassword = [Sitecore login Password]
   
   o	SolrUrl = [URL of solr server like https://ipAddress or server name/solr]
   
   o	SolrRoot = [Root location of Solr like C:\\solr-6.6.2]
   
   o	SolrService = [Solr Service Name]
   
   o	CommerceOpsServicesPort = [Port where DevOps need to setup like "5015"]
   
   o	CommerceShopsServicesPort = [Port where Shops need to setup like "5005"]
   
   o	CommerceAuthoringServicesPort = [Port where Auth need to setup like "5000"]
   
   o	CommerceMinionsServicesPort = = [Port where Minions need to setup like "5010"]
   
   o	CommerceOpsHostEntry = [Host Entry for Ops website like ops.dev.local]
   
   o	CommerceShopsHostEntry = [Host Entry for Shops website like shops.dev.local"]
   
   o	CommerceAuthoringHostEntry = [Host Entry for Auth website like "auth.dev.local"]
   
   o	CommerceMinionsHostEntry = [Host Entry for Minions website like minion.dev.local"]
   
   o	CommerceMinionsSiteName = [Minions website name in IIS like CommerceMinions_Sc9"]
   
   o	CommerceAuthoringSiteName = [Auth website name in IIS like  CommerceAuthoring_Sc9]
   
   o	CommerceOpsSiteName = [Ops website name in IIS like  "CommerceOps_Sc9"]
   
   o	CommerceShopsSiteName = [Shops website name in IIS like  "CommerceShops_Sc9"]
   
   o	DomainCertificateName = [Name of the domain certificate like "*.dev.local"]
   
   o	CommerceEngineCertificatePath = [Path where certificate is placed "C:\certs\devlocalclient.cer"]
   
   o	IdentitySiteName = [Identity website name in IIS like "SitecoreIdentityServer"]
   
   o	IdentityHostName = [Host Entry for Identity website like identity.dev.local"]
   
   o	IdentityPortId = [Port where Identity website need to setup like "5050"]
   
   o	BizFxSiteName = [BizFx website name in IIS like "SitecoreBizFx"]
   
   o	BizFxHostName = [Host Entry for BizFx website like "bizfx.dev.local"]
   
   o	BizFxPortId = [Port where BizFx website need to setup like "4200"]
   
   o	SQLServerUserName = [SQL Server username]
   
   o	SQLServerPassword = [SQL Server password]	

    
# Step 1: Generate domain certificate

o	If you have a SSL certificate then configure it on all the servers or create a self-signed domain certificate like ‘*.dev.local’ and install it on CMS, CD, BizFx, Identity, Authoring, Minion, Ops and Shops role.

# Step 2: Setup ‘Identity’ Role

o	Copy the Deploy folder created in ‘Step 0’ to C drive of Identity Server

o	Open "C:\deploy\SIF.Sitecore.Commerce.1.2.14\Deploy-Sitecore-Commerce.ps1" in Powershell

o	Set the value of RoleToBeDeployed = "Identity" and save the file. 

o	Run the powershell script.

o	Your Identity role will be created. Make sure proper binding is created in IIS, certificate is installed. Also validate host entry for identity in the host file.

o	Validate config entries appsettings.json file in identity server webroot.

o	Open ID Server port (like 5050) in the Firewall 

    
# Step 3: Setup ‘BizFx’ Role

o	Copy the Deploy folder created in ‘Step 0’ to C drive of BizFx Server

o	Open "C:\deploy\SIF.Sitecore.Commerce.1.2.14\Deploy-Sitecore-Commerce.ps1" in Powershell

o	Set the value of RoleToBeDeployed = "BizFx" and save the file. 

o	Run the powershell script.

o	Your BizFx role will be created. Make sure proper binding is created in IIS, certificate is installed. Also validate host entry for BizFx in the host file.

o	Validate config entries config.json file in identity server webroot.

o	Open BixFx Server port (like 4200) in the Firewall 

# Step 4: Setup ‘Ops’ Role

o	Copy the Deploy folder created in ‘Step 0’ to C drive of Ops Server

o	Open "C:\deploy\SIF.Sitecore.Commerce.1.2.14\Deploy-Sitecore-Commerce.ps1" in Powershell

o	Set the value of RoleToBeDeployed = "Ops" and save the file.

o	Run the powershell script.

o	Your Ops role will be created. Make sure proper binding is created in IIS, certificate is installed. Also validate host entry for Ops in the host file.

o	Open SQL Server and create a login for ‘CSFndRuntimeUser’ with password ‘Pu8azaCr’ (as mentioned in Deploy-Sitecore-Commerce.ps1. Assign db_owner role on SitecoreCommerce9U2_Global, SitecoreCommerce9U2_SharedEnvironments and <SQL DB prefix>_core DB’s.

o	Validate config entries wwwroot\config.json file in identity server webroot.

o	Open Ops Server port (like 5015) in the Firewall 

Note: 

•	While running the scripts, you might get following warning. Please ignore it:

Unable to delete database SitecoreCommerce9U2_SharedEnvironments and

Unable to delete database SitecoreCommerce9U2_Global

Also, you will get error while adding ‘CSFndRuntimeUser’ to SitecoreCommerce9U2_Global, SitecoreCommerce9U2_SharedEnvironments and <SQL DB prefix>_core DB, ignore it. 

•	I have tested putting Ops, Shops, Authoring and Minions on single server. Ideally it should work if we put it on separate servers. I will test it in coming days and update accordingly.

# Step 5: Setup ‘Authoring’ Role

o	Open "C:\deploy\SIF.Sitecore.Commerce.1.2.14\Deploy-Sitecore-Commerce.ps1" in Powershell

o	Set the value of RoleToBeDeployed = "Authoring" and save the file.

o	Run the powershell script.

o	Your Authoring role will be created. Make sure proper binding is created in IIS, certificate is installed. Also validate host entry for Authoring in the host file.

o	Validate config entries wwwroot\config.json file in identity server webroot.

o	Open Authoring Server port (like 5000) in the Firewall 

# Step 6: Setup ‘Shops’ Role

o	Open "C:\deploy\SIF.Sitecore.Commerce.1.2.14\Deploy-Sitecore-Commerce.ps1" in Powershell

o	Set the value of RoleToBeDeployed = "Shops" and save the file.

o	Run the powershell script.

o	Your Shops role will be created. Make sure proper binding is created in IIS, certificate is installed. Also validate host entry for Shops in the host file.

o	Validate config entries wwwroot\config.json file in identity server webroot.

o	Open Shops Server port (like 5005) in the Firewall 

Note: 

•	You might get and error while adding ‘CSFndRuntimeUser’ to <SQL DB prefix>_core DB, ignore it. 

# Step 7: Setup ‘Minions’ Role

o	Open "C:\deploy\SIF.Sitecore.Commerce.1.2.14\Deploy-Sitecore-Commerce.ps1" in Powershell

o	Set the value of RoleToBeDeployed = "Minions" and save the file.

o	Run the powershell script.

o	Your Minions role will be created. Make sure proper binding is created in IIS, certificate is installed. Also validate host entry for Authoring in the host file.

o	Validate config entries wwwroot\config.json file in identity server webroot.

o	Open Minions Server port (like 5010) in the Firewall 

# Step 8: Deploy Solr Cores for Commerce

o	Open "C:\deploy\SIF.Sitecore.Commerce.1.2.14\Deploy-Sitecore-Commerce.ps1" in Powershell

o	Set the value of RoleToBeDeployed = "Solr" and save the file.

o	Run the powershell script.

o	Three additional Solr Cores CatalogItemsScope, CustomersScope and OrdersScope will be created.

# Step 9: Deploy Commerce packages on Content Management Server

o	Open "C:\deploy\SIF.Sitecore.Commerce.1.2.14\Deploy-Sitecore-Commerce.ps1" in Powershell

o	Set the value of RoleToBeDeployed = "CM" and save the file.

o	Once installed, open CMS -> Control Panel and do ReIndexing.

o	Change the Detault Strorefront name

o	Change the BizFx Path in Core Database

# Step 10: Deploy Commerce packages on Content Delivery Server

o	Switch the Role of CD to CM and run the script.

o	Open "C:\deploy\SIF.Sitecore.Commerce.1.2.14\Deploy-Sitecore-Commerce.ps1"

o	Set the value of RoleToBeDeployed = "CD" and save the file.

o	Once installed, Switch back the Role from CM to CD.

o	Open App_Config -> Sitecore -> Marketing.Operations.xMgmt -> Sitecore.Marketing.Solr.Index.Web.config and update Sitecore_marketingdefinitions_web with [Your Instance Name]_marketingdefinitions_web


**Note: This script is currently tested on enviornment having CM and xConnect on same server. Testing in progress with xConnect on seperate server. Updates will be released soon.

For any information reach out to:
- Amit Mahajan : amit.mahajan@msn.com 
  (slack: @nicks)
- Saurabh Sachdeva: saurabhsachdeva10@gmail.com
 
