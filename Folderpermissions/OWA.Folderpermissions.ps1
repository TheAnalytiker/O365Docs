﻿# connect extended

$admin = ""

#Admin + PS check
Try { Set-ExecutionPolicy RemoteSigned -Force -EA stop } catch { Write-host "restart as Admin / check Permissions" -F Yellow }
if ($($PSVersionTable.PSVersion.ToString()) -lt "5") { Write-Host "Powerhell $($PSVersionTable.PSVersion.ToString()) doesn't support Install-module" -F yellow}

#admin
if (!($admin)) {$admin = read-host -Prompt "Enter Global Admin [Admin@domain.com]" }
#credential
if (!($cred)) {$cred = Get-Credential $admin}

#Trust Powershell Gallery
if (!(get-PackageProvider nuget)) { write-host "Adding NUGet Package Provider" -F green; Install-PackageProvider -Name NuGet -Force -Scope CurrentUser -Confirm:$false }
if ($((Get-PSRepository -Name "PSGallery").InstallationPolicy) -ne 'trusted') { write-host "Adding PSGallery Trust" -F green;Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted }

#MSOL Check / Login - Else TLS + install
if(Get-MsolDomain -ErrorAction SilentlyContinue) { Write-host 'MSOL connected' -F green} else { try { Connect-MsolService -Credential $cred } catch { 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
try {Install-Module MSOnline -Scope CurrentUser -Confirm:$false -EA stop } catch { Write-host $Error[0].Exception.Message -F yellow }
try { Connect-MsolService -Credential $cred -EA stop } catch { Write-host $Error[0].Exception.Message -F yellow }}}

# check EXO V2 Installed + Connect Exo
if (!(get-module ExchangeOnlineManagement)) { Try { Install-Module ExchangeOnlineManagement -Scope CurrentUser -Confirm:$false -EA stop } catch { Write-host $Error[0].Exception.Message -F yellow}}
Try{ Connect-ExchangeOnline -Credential $cred -EA stop } catch { Connect-ExchangeOnline -UserPrincipalName $admin }
