# Objective:
Deploy Sitecore 9 Update 2 on scaled environment by extending the available scripts.

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

# Assumptions:

XConnect is up and running on CM server. **

IIS and .NET Core is installed on all the servers where we are hosting following roles:

•	BizFx

•	Identity

•	Authoring

•	Minion

•	Shops 

•	Ops

**Working on updating and testing the scripts where XConnect is deployed on separate server.

# Overview:
Common PowerShell script is used to deploy all the roles and required packages. Just uncomment the required role in the PowerShell script and run it on a specific server. The PowerShell script will create the website, modify the required configuration, assign the required certificate and create the host entry.

# Recommendation:

Follow the steps mentioned in ‘Setting Up the Scripts’ on any one server and later copy it on all the servers to reduce the overall effort.

# Setting Up the Scripts:

•	Download Sitecore Experience Commerce (Sitecore XC) ‘On Premise’ package from https://dev.sitecore.net/Downloads/Sitecore_Commerce/90/Sitecore_Experience_Commerce_90_Update2.aspx

# Step 0

Unzip the package. For rest of the documentation I assume you have unzipped it on ‘C:\Deploy’ Folder.

•	Unzip following files inside c:\deploy folder

   o	Sitecore.Commerce.Engine.SDK.x.x.xxxx.zip

  o	Sitecore.BizFX.x.x.xxx.zip
    
•	Download all the zip files from github and unzip it in ‘C:\Deploy’ folder
    
# Step 1: Generate domain certificate

o	If you have a SSL certificate then configure it on all the servers or create a self-signed domain certificate like ‘*.dev.local’ and install it on CMS, CD, BizFx, Identity, Authoring, Minion, Ops and Shops role.
You can refer the scripts inside ‘c:\deploy\Generate-Script’ folder.
This script will generate the required ‘.cer’ and ‘.pfx’ with password as ‘secret’ at ‘C:\certs’ folder. Place the folder and install it on all the servers using ‘.pfx’ file. 

# Step 2: Setup ‘Identity’ Role

o	Copy the Deploy folder created in ‘Step 0’ to C drive of Identity Server

o	Open "C:\deploy\SIF.Sitecore.Commerce.1.2.14\Deploy-Sitecore-Commerce.ps1" in Powershell

o	Uncomment line just after ‘#Deploy Identity Role’ comment and save the file. (make sure all other entries are commented except this one)

o	Run the powershell script.

o	Your Identity role will be created. Make sure proper binding is created in IIS, certificate is installed. Also validate host entry for identity in the host file.

o	Validate config entries appsettings.json file in identity server webroot.

o	Open ID Server port (like 5050) in the Firewall 

    
# Step 3: Setup ‘BizFx’ Role

o	Copy the Deploy folder created in ‘Step 0’ to C drive of BizFx Server

o	Open "C:\deploy\SIF.Sitecore.Commerce.1.2.14\Deploy-Sitecore-Commerce.ps1" in Powershell

o	Uncomment line just after #Deploy BizFx Role’ comment and save the file. (make sure all other entries are commented except this one)

o	Run the powershell script.

o	Your BizFx role will be created. Make sure proper binding is created in IIS, certificate is installed. Also validate host entry for BizFx in the host file.

o	Validate config entries config.json file in identity server webroot.

o	Open BixFx Server port (like 4200) in the Firewall 

# Step 4: Setup ‘Ops’ Role

o	Copy the Deploy folder created in ‘Step 0’ to C drive of Ops Server

o	Open "C:\deploy\SIF.Sitecore.Commerce.1.2.14\Deploy-Sitecore-Commerce.ps1" in Powershell

o	Uncomment line just after ‘#Deploy Ops Role’ comment and save the file. (make sure all other entries are commented except this one)

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

o	Uncomment line just after ‘#Deploy Authoring Role’ comment and save the file. (make sure all other entries are commented except this one)

o	Run the powershell script.

o	Your Authoring role will be created. Make sure proper binding is created in IIS, certificate is installed. Also validate host entry for Authoring in the host file.

o	Validate config entries wwwroot\config.json file in identity server webroot.

o	Open Authoring Server port (like 5000) in the Firewall 

# Step 6: Setup ‘Shops’ Role

o	Open "C:\deploy\SIF.Sitecore.Commerce.1.2.14\Deploy-Sitecore-Commerce.ps1" in Powershell

o	Uncomment line just after ‘#Deploy Shops Role’ comment and save the file. (make sure all other entries are commented except this one)

o	Run the powershell script.

o	Your Shops role will be created. Make sure proper binding is created in IIS, certificate is installed. Also validate host entry for Shops in the host file.

o	Validate config entries wwwroot\config.json file in identity server webroot.

o	Open Shops Server port (like 5005) in the Firewall 

Note: 

•	You might get and error while adding ‘CSFndRuntimeUser’ to <SQL DB prefix>_core DB, ignore it. 

# Step 7: Setup ‘Minions’ Role

o	Open "C:\deploy\SIF.Sitecore.Commerce.1.2.14\Deploy-Sitecore-Commerce.ps1" in Powershell

o	Uncomment line just after ‘#Deploy Minions Role’ comment and save the file. (make sure all other entries are commented except this one)

o	Run the powershell script.

o	Your Minions role will be created. Make sure proper binding is created in IIS, certificate is installed. Also validate host entry for Authoring in the host file.

o	Validate config entries wwwroot\config.json file in identity server webroot.

o	Open Minions Server port (like 5010) in the Firewall 

# Step 8: Deploy Solr Cores for Commerce

o	Open "C:\deploy\SIF.Sitecore.Commerce.1.2.14\Deploy-Sitecore-Commerce.ps1" in Powershell

o	Uncomment line just after ‘#Deploy Solr Cores’ comment and save the file. (make sure all other entries are commented except this one)

o	Run the powershell script.

o	Three additional Solr Cores CatalogItemsScope, CustomersScope and OrdersScope will be created.

# Step 9: Deploy Commerce packages on Content Management Server

o	Open "C:\deploy\SIF.Sitecore.Commerce.1.2.14\Deploy-Sitecore-Commerce.ps1" in Powershell

o	Uncomment line just after ‘#Deploy CMS Packages’ comment and save the file. (make sure all other entries are commented except this one)

o	Once installed, open CMS -> Control Panel and do ReIndexing.

o	Change the Detault Strorefront name

o	Change the BizFx Path in Core Database

# Step 10: Deploy Commerce packages on Content Delivery Server

o	Switch the Role of CD to CM and run the script.

o	Open "C:\deploy\SIF.Sitecore.Commerce.1.2.14\Deploy-Sitecore-Commerce.ps1"

o	Uncomment line just after ‘#Deploy CD Packages’ comment and save the file. (make sure all other entries are commented except this one)

o	Once installed, Switch back the Role from CM to CD.

o	Open App_Config -> Sitecore -> Marketing.Operations.xMgmt -> Sitecore.Marketing.Lucene.Index.Web.config and change "sitecore_marketingdefinitions_web" with "<your instance>-marketingdefinitions_web"
