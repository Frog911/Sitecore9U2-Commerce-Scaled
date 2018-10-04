#Requires -Version 3
param(
    #UPDATE AS PER YOUR ENV. BEGIN
    [string]$SiteName = "xp05.dev.local",	
	[string]$SiteHostHeaderName = "sxasfU05.dev.local",	
	[string]$SqlDbPrefix = "xp05",
	[string]$CommerceSearchProvider = "SOLR"
    #UPDATE AS PER YOUR ENV. END
)

$global:DEPLOYMENT_DIRECTORY=Split-Path $MyInvocation.MyCommand.Path
$modulesPath=( Join-Path -Path $DEPLOYMENT_DIRECTORY -ChildPath "Modules" )
if ($env:PSModulePath -notlike "*$modulesPath*")
{
    $p = $env:PSModulePath + ";" + $modulesPath
    [Environment]::SetEnvironmentVariable("PSModulePath",$p)
}

#new variables defined in master_singleServer.json
$SifPath = "" #path till \Configuration folder (e.g E:\SIF.Sitecore.Commerce.1.2.14)
$CommerceInstallDir = "D:\project" #path to install commerce sites


$params = @{
        Path = Resolve-Path '.\Configuration\Commerce\Master_SingleServer.json'	

		SiteName = $SiteName
		SiteHostHeaderName = $SiteHostHeaderName 
		InstallDir = "$($Env:SYSTEMDRIVE)\inetpub\wwwroot\$SiteName"
		XConnectInstallDir = "C:\inetpub\wwwroot\xp05xc.dev.local"
        CertificateName = $SiteName        
        SolrSchemas = ( Join-Path -Path $DEPLOYMENT_DIRECTORY -ChildPath "SolrSchemas" )
		SearchIndexPrefix = ""
		AzureSearchServiceName = ""
		AzureSearchAdminKey = ""
		AzureSearchQueryKey = ""
		CommerceEngineDacPac = Resolve-Path -Path "..\Sitecore.Commerce.Engine.SDK.*\Sitecore.Commerce.Engine.DB.dacpac"	 
        
        #new params
        SifPath = $SifPath
        CommerceInstallDir = $CommerceInstallDir	

        #UPDATE AS PER YOUR ENV. BEGIN
        CommerceServicesDbServer = "your db server ip"    #OR "SQLServerName\SQLInstanceName"
		CommerceServicesDbName = "SitecoreCommerce9U2_SharedEnvironments"
		CommerceServicesGlobalDbName = "SitecoreCommerce9U2_Global"		
        SitecoreDbServer = "your db server ip"            #OR "SQLServerName\SQLInstanceName"
		SitecoreCoreDbName = "$($SqlDbPrefix)_Core"
		SitecoreUsername = "sitecore\admin"
		SitecoreUserPassword = "b"
		CommerceSearchProvider = $CommerceSearchProvider
		SolrUrl = "https://solr ip:port/solr"
		SolrRoot = "C:\\solr-6.6.2"
		SolrService = "solr662"
        CommerceOpsServicesPort = "5015"
		CommerceShopsServicesPort = "5005"
		CommerceAuthoringServicesPort = "5000"
		CommerceMinionsServicesPort = "5010"
        CommerceOpsHostEntry = "ops.dev.local"
		CommerceShopsHostEntry = "shops.dev.local"
		CommerceAuthoringHostEntry = "auth.dev.local"
		CommerceMinionsHostEntry = "minion.dev.local"
        CommerceMinionsSiteName = "CommerceMinions_Sc9"
        CommerceAuthoringSiteName = "CommerceAuthoring_Sc9"
        CommerceOpsSiteName = "CommerceOps_Sc9"
        CommerceShopsSiteName = "CommerceShops_Sc9"
        DomainCertificateName = "*.dev.local"
        CommerceEngineCertificatePath = "C:\certs\devlocalclient.cer" #"C:\deploy\devLocalCert.cer"	
        
        SitecoreIdentityServerName = "SitecoreIdentityServer"        
        IdentitySiteName = "SitecoreIdentityServer"
        IdentityHostName = "identity.dev.local"
        IdentityPortId = "5050"
		
        BizFxSiteName = "SitecoreBizFx"
        BizFxHostName = "bizfx.dev.local"
        BizFxPortId = "4200"
        
        SQLServerUserName = "your sql server username"
        SQLServerPassword = "your sql server password"
        	
        #UPDATE AS PER YOUR ENV. END		


		SitecoreCommerceEngineZipPath = "C:\deploy\Sitecore.Commerce.Engine.*.zip"		
		SitecoreBizFxServicesContentPath = "C:\deploy\Sitecore.BizFX.*"		
		SitecoreIdentityServerZipPath = "C:\deploy\Sitecore.IdentityServer.1.*.zip"
		
        SiteUtilitiesSrc = ( Join-Path -Path $DEPLOYMENT_DIRECTORY -ChildPath "SiteUtilityPages" )	
        
		HabitatImagesModuleFullPath = "C:\deploy\Sitecore.Commerce.Habitat.Images-*.zip"	
        AdvImagesModuleFullPath = "C:\deploy\Adventure Works Images.zip"	
		CommerceConnectModuleFullPath = "C:\deploy\Sitecore Commerce Connect*.zip"	
		CommercexProfilesModuleFullPath = "C:\deploy\Sitecore Commerce ExperienceProfile Core *.zip"	
		CommercexAnalyticsModuleFullPath = "C:\deploy\Sitecore Commerce ExperienceAnalytics Core *.zip"	
		CommerceMAModuleFullPath = "C:\deploy\Sitecore Commerce Marketing Automation Core *.zip"	
		CommerceMAForAutomationEngineModuleFullPath = "C:\deploy\Sitecore Commerce Marketing Automation for AutomationEngine *.zip"	
        CEConnectPackageFullPath = "C:\deploy\Sitecore.Commerce.Engine.Connect*.update"
        PowerShellExtensionsModuleFullPath = "C:\deploy\assets\Sitecore PowerShell Extensions*.zip"
        SXAModuleFullPath = "C:\deploy\assets\Sitecore Experience Accelerator*.zip"
        SXACommerceModuleFullPath = "C:\deploy\Sitecore Commerce Experience Accelerator 1.*.zip"
		SXAStorefrontModuleFullPath = "C:\deploy\Sitecore Commerce Experience Accelerator Storefront 1.*.zip"
        SXAStorefrontThemeModuleFullPath = "C:\deploy\Sitecore Commerce Experience Accelerator Storefront Themes*.zip"
		SXAStorefrontCatalogModuleFullPath = "C:\deploy\Sitecore Commerce Experience Accelerator Habitat Catalog*.zip"
		MergeToolFullPath = Resolve-Path -Path "C:\deploy\assets\Microsoft.Web.XmlTransform.dll"
		UserAccount = @{
			Domain = $Env:COMPUTERNAME
			UserName = 'CSFndRuntimeUser'
			Password = 'Pu8azaCr'
		}
        LocalUserAccount = @{
			Domain =  $Env:COMPUTERNAME
			UserName = 'CSFndRuntimeUser'
			Password = 'Pu8azaCr'
		}
		BraintreeAccount = @{
			MerchantId = 'your merchant id'
			PublicKey = 'your public key'
			PrivateKey = 'your private key'
		}
        BizFXInstallDir = ""
        IdentityInstallDir = ""
    }
   
   
  $params.BizFXInstallDir = "$($Env:SYSTEMDRIVE)\inetpub\wwwroot\$($params.BizFxSiteName)"
  $params.IdentityInstallDir = "$($Env:SYSTEMDRIVE)\inetpub\wwwroot\$($params.IdentitySiteName)"
 
   

if ($CommerceSearchProvider -eq "SOLR") {
	 #########################################################################
    #Deploy BizFx
	#Install-SitecoreConfiguration @params -Tasks DeploySitecoreBizFx,CreateBindings,CreateHostHeader,UpdateBizFxConfigs -ErrorAction Continue -Verbose
    #########################################################################

    #########################################################################
    #Deploy Identity
    #Install-SitecoreConfiguration @params -Tasks DeploySitecoreIdentityServer,CreateIdentityBindings,CreateIdentityHostHeader,UpdateIdentityConfigs -ErrorAction Continue
    #########################################################################

    #########################################################################
    #Deploy Ops
    #Install-SitecoreConfiguration @params -Tasks DeployCommerceEngineOps,CreateOpsBindings,CreateOpsHostHeader -ErrorAction Continue
    #########################################################################

    #########################################################################
    #Deploy Shops
    #Install-SitecoreConfiguration @params -Tasks DeployCommerceEngineShops,CreateShopsBindings,CreateShopsHostHeader -ErrorAction Continue
    #########################################################################

    #########################################################################
    #Deploy Authoring
   # Install-SitecoreConfiguration @params -Tasks DeployCommerceEngineAuthoring,CreateAuthoringBindings,CreateAuthoringHostHeader -ErrorAction Continue
    #########################################################################
        
    #########################################################################
    #Deploy Minions
   #Install-SitecoreConfiguration @params -Tasks DeployCommerceEngineMinions,CreateMinionsBindings,CreateMinionsHostHeader -ErrorAction Continue
    #########################################################################
    
    #########################################################################
    #Deploy Solr
	#Install-SitecoreConfiguration @params -Tasks InstallSolrCores -ErrorAction Continue -Verbose
    #########################################################################

    #########################################################################
    #Deploy CMS InitializeCommerceEngine,UpdateShopsOpsURI
    #Install-SitecoreConfiguration @params -Tasks CreateBinding,CopySiteUtilityFolder,DisableIndexUpdate,DisableConfigFiles,InstallPowershellExtensions,InstallSXAFrameworkModule,PublishExtensions,InstallHabitatImagesModule,InstallAdventureWorksImagesModule,InstallCommerceConnectModule,InstallCommercexProfilesModule,InstallCommercexAnalyticsModule,InstallCommerceMAModule,InstallCommerceEngineConnectModule,CopyConnectModels,InstallSXAStorefrontModule,ImportRootCertificate,UpdateWebsiteConfigs,InitializeCommerceEngine,UpdateShopsOpsURI,EnableCEConnectDataProvider,GenerateCatalogTemplates,CreateDefaultTenantAndSite,PublishCommerce,EnableIndexUpdate,EnableConfigFiles,EnableCEConnectIndexing,Reindex,RemoveSiteUtilityFolder -ErrorAction Continue -Verbose
    #########################################################################

    #########################################################################
    #Deploy CD 
    #Install-SitecoreConfiguration @params -Tasks ImportRootCertificate,EnableCEConnectDataProvider,EnableIndexUpdate,EnableConfigFiles,EnableCEConnectIndexing,RemoveSiteUtilityFolder -ErrorAction Continue -Verbose
    ########################
}
elseif ($CommerceSearchProvider -eq "AZURE"){
	Install-SitecoreConfiguration @params -Skip InstallSolrCores
}
# SIG # Begin signature block
# MIIXwQYJKoZIhvcNAQcCoIIXsjCCF64CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU2A4zbikI1U2u89We6OodK+3R
# VQ+gghL8MIID7jCCA1egAwIBAgIQfpPr+3zGTlnqS5p31Ab8OzANBgkqhkiG9w0B
# AQUFADCBizELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTEUMBIG
# A1UEBxMLRHVyYmFudmlsbGUxDzANBgNVBAoTBlRoYXd0ZTEdMBsGA1UECxMUVGhh
# d3RlIENlcnRpZmljYXRpb24xHzAdBgNVBAMTFlRoYXd0ZSBUaW1lc3RhbXBpbmcg
# Q0EwHhcNMTIxMjIxMDAwMDAwWhcNMjAxMjMwMjM1OTU5WjBeMQswCQYDVQQGEwJV
# UzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFu
# dGVjIFRpbWUgU3RhbXBpbmcgU2VydmljZXMgQ0EgLSBHMjCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBALGss0lUS5ccEgrYJXmRIlcqb9y4JsRDc2vCvy5Q
# WvsUwnaOQwElQ7Sh4kX06Ld7w3TMIte0lAAC903tv7S3RCRrzV9FO9FEzkMScxeC
# i2m0K8uZHqxyGyZNcR+xMd37UWECU6aq9UksBXhFpS+JzueZ5/6M4lc/PcaS3Er4
# ezPkeQr78HWIQZz/xQNRmarXbJ+TaYdlKYOFwmAUxMjJOxTawIHwHw103pIiq8r3
# +3R8J+b3Sht/p8OeLa6K6qbmqicWfWH3mHERvOJQoUvlXfrlDqcsn6plINPYlujI
# fKVOSET/GeJEB5IL12iEgF1qeGRFzWBGflTBE3zFefHJwXECAwEAAaOB+jCB9zAd
# BgNVHQ4EFgQUX5r1blzMzHSa1N197z/b7EyALt0wMgYIKwYBBQUHAQEEJjAkMCIG
# CCsGAQUFBzABhhZodHRwOi8vb2NzcC50aGF3dGUuY29tMBIGA1UdEwEB/wQIMAYB
# Af8CAQAwPwYDVR0fBDgwNjA0oDKgMIYuaHR0cDovL2NybC50aGF3dGUuY29tL1Ro
# YXd0ZVRpbWVzdGFtcGluZ0NBLmNybDATBgNVHSUEDDAKBggrBgEFBQcDCDAOBgNV
# HQ8BAf8EBAMCAQYwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0y
# MDQ4LTEwDQYJKoZIhvcNAQEFBQADgYEAAwmbj3nvf1kwqu9otfrjCR27T4IGXTdf
# plKfFo3qHJIJRG71betYfDDo+WmNI3MLEm9Hqa45EfgqsZuwGsOO61mWAK3ODE2y
# 0DGmCFwqevzieh1XTKhlGOl5QGIllm7HxzdqgyEIjkHq3dlXPx13SYcqFgZepjhq
# IhKjURmDfrYwggSjMIIDi6ADAgECAhAOz/Q4yP6/NW4E2GqYGxpQMA0GCSqGSIb3
# DQEBBQUAMF4xCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
# dGlvbjEwMC4GA1UEAxMnU3ltYW50ZWMgVGltZSBTdGFtcGluZyBTZXJ2aWNlcyBD
# QSAtIEcyMB4XDTEyMTAxODAwMDAwMFoXDTIwMTIyOTIzNTk1OVowYjELMAkGA1UE
# BhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMTQwMgYDVQQDEytT
# eW1hbnRlYyBUaW1lIFN0YW1waW5nIFNlcnZpY2VzIFNpZ25lciAtIEc0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAomMLOUS4uyOnREm7Dv+h8GEKU5Ow
# mNutLA9KxW7/hjxTVQ8VzgQ/K/2plpbZvmF5C1vJTIZ25eBDSyKV7sIrQ8Gf2Gi0
# jkBP7oU4uRHFI/JkWPAVMm9OV6GuiKQC1yoezUvh3WPVF4kyW7BemVqonShQDhfu
# ltthO0VRHc8SVguSR/yrrvZmPUescHLnkudfzRC5xINklBm9JYDh6NIipdC6Anqh
# d5NbZcPuF3S8QYYq3AhMjJKMkS2ed0QfaNaodHfbDlsyi1aLM73ZY8hJnTrFxeoz
# C9Lxoxv0i77Zs1eLO94Ep3oisiSuLsdwxb5OgyYI+wu9qU+ZCOEQKHKqzQIDAQAB
# o4IBVzCCAVMwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAO
# BgNVHQ8BAf8EBAMCB4AwcwYIKwYBBQUHAQEEZzBlMCoGCCsGAQUFBzABhh5odHRw
# Oi8vdHMtb2NzcC53cy5zeW1hbnRlYy5jb20wNwYIKwYBBQUHMAKGK2h0dHA6Ly90
# cy1haWEud3Muc3ltYW50ZWMuY29tL3Rzcy1jYS1nMi5jZXIwPAYDVR0fBDUwMzAx
# oC+gLYYraHR0cDovL3RzLWNybC53cy5zeW1hbnRlYy5jb20vdHNzLWNhLWcyLmNy
# bDAoBgNVHREEITAfpB0wGzEZMBcGA1UEAxMQVGltZVN0YW1wLTIwNDgtMjAdBgNV
# HQ4EFgQURsZpow5KFB7VTNpSYxc/Xja8DeYwHwYDVR0jBBgwFoAUX5r1blzMzHSa
# 1N197z/b7EyALt0wDQYJKoZIhvcNAQEFBQADggEBAHg7tJEqAEzwj2IwN3ijhCcH
# bxiy3iXcoNSUA6qGTiWfmkADHN3O43nLIWgG2rYytG2/9CwmYzPkSWRtDebDZw73
# BaQ1bHyJFsbpst+y6d0gxnEPzZV03LZc3r03H0N45ni1zSgEIKOq8UvEiCmRDoDR
# EfzdXHZuT14ORUZBbg2w6jiasTraCXEQ/Bx5tIB7rGn0/Zy2DBYr8X9bCT2bW+IW
# yhOBbQAuOA2oKY8s4bL0WqkBrxWcLC9JG9siu8P+eJRRw4axgohd8D20UaF5Mysu
# e7ncIAkTcetqGVvP6KUwVyyJST+5z3/Jvz4iaGNTmr1pdKzFHTx/kuDDvBzYBHUw
# ggUrMIIEE6ADAgECAhAHplztCw0v0TJNgwJhke9VMA0GCSqGSIb3DQEBCwUAMHIx
# CzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3
# dy5kaWdpY2VydC5jb20xMTAvBgNVBAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJ
# RCBDb2RlIFNpZ25pbmcgQ0EwHhcNMTcwODIzMDAwMDAwWhcNMjAwOTMwMTIwMDAw
# WjBoMQswCQYDVQQGEwJVUzELMAkGA1UECBMCY2ExEjAQBgNVBAcTCVNhdXNhbGl0
# bzEbMBkGA1UEChMSU2l0ZWNvcmUgVVNBLCBJbmMuMRswGQYDVQQDExJTaXRlY29y
# ZSBVU0EsIEluYy4wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC7PZ/g
# huhrQ/p/0Cg7BRrYjw7ZMx8HNBamEm0El+sedPWYeAAFrjDSpECxYjvK8/NOS9dk
# tC35XL2TREMOJk746mZqia+g+NQDPEaDjNPG/iT0gWsOeCa9dUcIUtnBQ0hBKsuR
# bau3n7w1uIgr3zf29vc9NhCoz1m2uBNIuLBlkKguXwgPt4rzj66+18JV3xyLQJoS
# 3ZAA8k6FnZltNB+4HB0LKpPmF8PmAm5fhwGz6JFTKe+HCBRtuwOEERSd1EN7TGKi
# xczSX8FJMz84dcOfALxjTj6RUF5TNSQLD2pACgYWl8MM0lEtD/1eif7TKMHqaA+s
# m/yJrlKEtOr836BvAgMBAAGjggHFMIIBwTAfBgNVHSMEGDAWgBRaxLl7Kgqjpepx
# A8Bg+S32ZXUOWDAdBgNVHQ4EFgQULh60SWOBOnU9TSFq0c2sWmMdu7EwDgYDVR0P
# AQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMHcGA1UdHwRwMG4wNaAzoDGG
# L2h0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9zaGEyLWFzc3VyZWQtY3MtZzEuY3Js
# MDWgM6Axhi9odHRwOi8vY3JsNC5kaWdpY2VydC5jb20vc2hhMi1hc3N1cmVkLWNz
# LWcxLmNybDBMBgNVHSAERTBDMDcGCWCGSAGG/WwDATAqMCgGCCsGAQUFBwIBFhxo
# dHRwczovL3d3dy5kaWdpY2VydC5jb20vQ1BTMAgGBmeBDAEEATCBhAYIKwYBBQUH
# AQEEeDB2MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wTgYI
# KwYBBQUHMAKGQmh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFNI
# QTJBc3N1cmVkSURDb2RlU2lnbmluZ0NBLmNydDAMBgNVHRMBAf8EAjAAMA0GCSqG
# SIb3DQEBCwUAA4IBAQBozpJhBdsaz19E9faa/wtrnssUreKxZVkYQ+NViWeyImc5
# qEZcDPy3Qgf731kVPnYuwi5S0U+qyg5p1CNn/WsvnJsdw8aO0lseadu8PECuHj1Z
# 5w4mi5rGNq+QVYSBB2vBh5Ps5rXuifBFF8YnUyBc2KuWBOCq6MTRN1H2sU5LtOUc
# Qkacv8hyom8DHERbd3mIBkV8fmtAmvwFYOCsXdBHOSwQUvfs53GySrnIYiWT0y56
# mVYPwDj7h/PdWO5hIuZm6n5ohInLig1weiVDJ254r+2pfyyRT+02JVVxyHFMCLwC
# ASs4vgbiZzMDltmoTDHz9gULxu/CfBGM0waMDu3cMIIFMDCCBBigAwIBAgIQBAkY
# G1/Vu2Z1U0O1b5VQCDANBgkqhkiG9w0BAQsFADBlMQswCQYDVQQGEwJVUzEVMBMG
# A1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSQw
# IgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJvb3QgQ0EwHhcNMTMxMDIyMTIw
# MDAwWhcNMjgxMDIyMTIwMDAwWjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGln
# aUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhE
# aWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgQ29kZSBTaWduaW5nIENBMIIBIjANBgkq
# hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA+NOzHH8OEa9ndwfTCzFJGc/Q+0WZsTrb
# RPV/5aid2zLXcep2nQUut4/6kkPApfmJ1DcZ17aq8JyGpdglrA55KDp+6dFn08b7
# KSfH03sjlOSRI5aQd4L5oYQjZhJUM1B0sSgmuyRpwsJS8hRniolF1C2ho+mILCCV
# rhxKhwjfDPXiTWAYvqrEsq5wMWYzcT6scKKrzn/pfMuSoeU7MRzP6vIK5Fe7SrXp
# dOYr/mzLfnQ5Ng2Q7+S1TqSp6moKq4TzrGdOtcT3jNEgJSPrCGQ+UpbB8g8S9MWO
# D8Gi6CxR93O8vYWxYoNzQYIH5DiLanMg0A9kczyen6Yzqf0Z3yWT0QIDAQABo4IB
# zTCCAckwEgYDVR0TAQH/BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYwEwYDVR0l
# BAwwCgYIKwYBBQUHAwMweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRw
# Oi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRz
# LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwgYEGA1Ud
# HwR6MHgwOqA4oDaGNGh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFz
# c3VyZWRJRFJvb3RDQS5jcmwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNv
# bS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwTwYDVR0gBEgwRjA4BgpghkgB
# hv1sAAIEMCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9D
# UFMwCgYIYIZIAYb9bAMwHQYDVR0OBBYEFFrEuXsqCqOl6nEDwGD5LfZldQ5YMB8G
# A1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3zbcgPMA0GCSqGSIb3DQEBCwUAA4IB
# AQA+7A1aJLPzItEVyCx8JSl2qB1dHC06GsTvMGHXfgtg/cM9D8Svi/3vKt8gVTew
# 4fbRknUPUbRupY5a4l4kgU4QpO4/cY5jDhNLrddfRHnzNhQGivecRk5c/5CxGwcO
# kRX7uq+1UcKNJK4kxscnKqEpKBo6cSgCPC6Ro8AlEeKcFEehemhor5unXCBc2XGx
# DI+7qPjFEmifz0DLQESlE/DmZAwlCEIysjaKJAL+L3J+HNdJRZboWR3p+nRka7Lr
# ZkPas7CM1ekN3fYBIM6ZMWM9CBoYs4GbT8aTEAb8B4H6i9r5gkn3Ym6hU/oSlBiF
# LpKR6mhsRDKyZqHnGKSaZFHvMYIELzCCBCsCAQEwgYYwcjELMAkGA1UEBhMCVVMx
# FTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNv
# bTExMC8GA1UEAxMoRGlnaUNlcnQgU0hBMiBBc3N1cmVkIElEIENvZGUgU2lnbmlu
# ZyBDQQIQB6Zc7QsNL9EyTYMCYZHvVTAJBgUrDgMCGgUAoHAwEAYKKwYBBAGCNwIB
# DDECMAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFFhL5ZmCLq9hUiVOrIhi7tNi
# NKdiMA0GCSqGSIb3DQEBAQUABIIBAH/rxB1j9CVdi/h3Z5ID/mjQbwHTOfchRIjf
# Zbar9Os6ApXTt1BucBvWvjnuhBitrglg3Ye34VKfcrCwpwDMB9yYefVqhcQt6nmN
# j6jZ/jAbpQ1NUfacVp4j0vSJzdYJx6hBSvkCDOsYI8dE41dY9KG1qGO6ENeph7hN
# FlenP5jAvSgI7cP9SwSLhXqAYkafISStBoEDVDoImcebsqzdCLrI2vEfrJykekZJ
# bzLYTIdSBA239FLPLgfSi8JMxmR91buc9FxX5KuSBsBQ5WVAn7Zv35MIJ5YJ9/hC
# nfH7iYcDvbuK7UKW+qJ8/WeuXRtTQeYn7Rkr3pgED1vC0DcbBxOhggILMIICBwYJ
# KoZIhvcNAQkGMYIB+DCCAfQCAQEwcjBeMQswCQYDVQQGEwJVUzEdMBsGA1UEChMU
# U3ltYW50ZWMgQ29ycG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFudGVjIFRpbWUgU3Rh
# bXBpbmcgU2VydmljZXMgQ0EgLSBHMgIQDs/0OMj+vzVuBNhqmBsaUDAJBgUrDgMC
# GgUAoF0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcN
# MTgwNjE0MTc1MTQwWjAjBgkqhkiG9w0BCQQxFgQU4dRV4mrmlmo23fz23U6f5lkM
# xjAwDQYJKoZIhvcNAQEBBQAEggEAe2TShd9FJInWxz/vZmn/mBW8zhOXCHPGgSz8
# pJr3BG0aBJ1wOoglnqwS9fEdHjs/RLHdXEKVBo5KSaPWeC2fYGLR43sTCcqwNTsX
# LEAfg9DrbiJLcB49od00oge74MXvfCb6eqBPVbCPTcgjlt+UyJ3ldRo/gUVH5Mly
# GRVlrdRXxGIvTrCxJdQ4u8zMhHSie4R2aWzv6L0TF63uIIFoVxpnzQNGKNftn3jt
# 2UU34gYl4I8e1vPpAoFfPLHWMi/qr7mqjg4LVQnNMpRyJuzGmoBXMFmBnLgkPecu
# tjnbFxotTOEywlOHvIg9F4JRRQ7TSya7+I56fWz7M2b7vWx8hg==
# SIG # End signature block
