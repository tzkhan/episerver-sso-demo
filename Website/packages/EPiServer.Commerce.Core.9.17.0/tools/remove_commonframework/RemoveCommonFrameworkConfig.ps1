<#
.SYNOPSIS
Removes EPiServer CommonFramework related configuration.

.DESCRIPTION
Removes EPiServer CommonFramework related configuration from web.config, EPiServerFramework.config
and connectionStrings.config.

Note: This scripts supports only the scenario where the episerver.framework and connectionStrings
sections are in separate files and all other Common Framework related config (e.g. the sections
episerver.common, nhibernate, hibernate-configuration and episerver.shell) is in web.config.

.PARAMETER sitePath
Path to the root folder of the site (containing web.config, EPiServerFramework.config and
connectionStrings.config).

#>

param ([string] $sitePath)

$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Path

Import-Module $scriptPath\Modules\Remove-EPiCommonFromWebConfig.psm1
Import-Module $scriptPath\Modules\Remove-EPiCommonFromEPiFxConfig.psm1
Import-Module $scriptPath\Modules\Remove-EPiCommonFromConnectionStringsConfig.psm1

if ($sitePath) {
	$sitePath = Resolve-Path $sitePath
}
else {
	throw "You have to specify the path to the site root."
}

$webConfigPath = Join-Path $sitePath web.config
if (Test-Path $webConfigPath) {
	$webConfigFile = Get-Item $webConfigPath

	[xml]$webConfig = Get-Content $webConfigFile
	if (Remove-EPiCommonFromWebConfig $webConfig) {
		Write-Host "Saving changes to $webConfigFile"
		$webConfig.Save($webConfigFile.FullName)
	} else {
		Write-Host "No changes required in $webConfigFile"
	}
} else {
	Write-Warning "No web.config file found in $sitePath"
}

$epiFxConfigPath = Join-Path $sitePath episerverFramework.config
if (Test-Path $epiFxConfigPath) {
	$epiFxConfigFile = Get-Item $epiFxConfigPath

	[xml]$epiFxConfig = Get-Content $epiFxConfigFile

	if (Remove-EPiCommonFromEPiFxConfig $epiFxConfig) {
		Write-Host "Saving changes to $epiFxConfigFile"
		$epiFxConfig.Save($epiFxConfigFile.FullName)
	} else {
		Write-Host "No changes required in $epiFxConfigFile"
	}
} else {
	Write-Warning "No EPiServerFramework.config found in $sitePath"
}

$connectionStringsConfigPath = Join-Path $sitePath connectionStrings.config
if (Test-Path $connectionStringsConfigPath) {
	$connectionStringsConfigFile = Get-Item $connectionStringsConfigPath

	[xml]$connectionStringsConfig = Get-Content $connectionStringsConfigFile

	if (Remove-EPiCommonFromConnectionStringsConfig $connectionStringsConfig) {
		Write-Host "Saving changes to $connectionStringsConfigFile"
		$connectionStringsConfig.Save($connectionStringsConfigFile.FullName)
	} else {
		Write-Host "No changes required in $connectionStringsConfigFile"
	}
} else {
	Write-Warning "No connectionStrings.config file found in $sitePath"
}

# SIG # Begin signature block
# MIIXpAYJKoZIhvcNAQcCoIIXlTCCF5ECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU/8sADi0nB8II5hxpJyrqh7NC
# L4igghLKMIID7jCCA1egAwIBAgIQfpPr+3zGTlnqS5p31Ab8OzANBgkqhkiG9w0B
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
# ggTQMIIDuKADAgECAhASn/W83LmZkqPf6+aeK2mOMA0GCSqGSIb3DQEBCwUAMH8x
# CzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0G
# A1UECxMWU3ltYW50ZWMgVHJ1c3QgTmV0d29yazEwMC4GA1UEAxMnU3ltYW50ZWMg
# Q2xhc3MgMyBTSEEyNTYgQ29kZSBTaWduaW5nIENBMB4XDTE2MDExMzAwMDAwMFoX
# DTE5MDQxMzIzNTk1OVowYzELMAkGA1UEBhMCU0UxEjAQBgNVBAgTCVNUT0NLSE9M
# TTESMBAGA1UEBxMJU1RPQ0tIT0xNMRUwEwYDVQQKFAxFUGlTZXJ2ZXIgQUIxFTAT
# BgNVBAMUDEVQaVNlcnZlciBBQjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
# ggEBALWsGwJJX/DKwasEkA9qAsdlsqP8SjVHN7lXwAt2CfBjDI0rN8DO20OfCgos
# Dw1rsSAs1iNNFrB6tdzM+wXZQrHE+bJAYvEXzmZM1kSQfCLz6qIwxx3cRIz8u3Wb
# lH391Dqz03Hf6Ds8N42QKv3m9gQP6g1OIPwlziVkgZ4ANdAP4CfTKPmg0kFqW+az
# WQs+ccYOZEWBi4oPIvPv1uwAbAKIK9fArAtrta7vIdtNf2FZftuL/kAjz980wDFY
# moYR4IGY2eT0FETkoi+dQOhxIbZEl5ziPr5cpiHDWt3J5gueoQCEhiKFg9Uzoquj
# 07IyexmtsjtDsMenkwOSGt2aefMCAwEAAaOCAWIwggFeMAkGA1UdEwQCMAAwDgYD
# VR0PAQH/BAQDAgeAMCsGA1UdHwQkMCIwIKAeoByGGmh0dHA6Ly9zdi5zeW1jYi5j
# b20vc3YuY3JsMGYGA1UdIARfMF0wWwYLYIZIAYb4RQEHFwMwTDAjBggrBgEFBQcC
# ARYXaHR0cHM6Ly9kLnN5bWNiLmNvbS9jcHMwJQYIKwYBBQUHAgIwGQwXaHR0cHM6
# Ly9kLnN5bWNiLmNvbS9ycGEwEwYDVR0lBAwwCgYIKwYBBQUHAwMwVwYIKwYBBQUH
# AQEESzBJMB8GCCsGAQUFBzABhhNodHRwOi8vc3Yuc3ltY2QuY29tMCYGCCsGAQUF
# BzAChhpodHRwOi8vc3Yuc3ltY2IuY29tL3N2LmNydDAfBgNVHSMEGDAWgBSWO1Pw
# eTOXr32D7y4rzMq3hh5yZjAdBgNVHQ4EFgQUlelWRKcMMuDX80+oWbXEPaHUd7sw
# DQYJKoZIhvcNAQELBQADggEBAIaGfEvw4rJgaEDow3Aea6Fg4LGxAtezhs6bjDZi
# h/IJdcWV1nEc/uhZ5XegmRXn3LaP2RL+ZHmjWrQxv4/aK/ZCFxBV0omny3VnIXsY
# UldnW8589S3a83Dtb3cpF+P57M8Z+Fwt+gyvQJYAyDrpMvgMdOotVFWUVVDESXV/
# ttYmhg3MC0ZLuWHREKR9Jrqe9aFjjbGbQlb8jKBOBDPSykjR2nnb5lBgXyfDG9Gf
# zfzz/ed2V95/NSyk2RQD3Wo/IiR/TMABuJEXzsGIMBGSHe6Yz58IxXox4WNyn26o
# 8NklVx6UVsquwXFANU0b4Z/FDTt0cr4PjxNb/Ww/ogKdSBMwggVZMIIEQaADAgEC
# AhA9eNf5dklgsmF99PAeyoYqMA0GCSqGSIb3DQEBCwUAMIHKMQswCQYDVQQGEwJV
# UzEXMBUGA1UEChMOVmVyaVNpZ24sIEluYy4xHzAdBgNVBAsTFlZlcmlTaWduIFRy
# dXN0IE5ldHdvcmsxOjA4BgNVBAsTMShjKSAyMDA2IFZlcmlTaWduLCBJbmMuIC0g
# Rm9yIGF1dGhvcml6ZWQgdXNlIG9ubHkxRTBDBgNVBAMTPFZlcmlTaWduIENsYXNz
# IDMgUHVibGljIFByaW1hcnkgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgLSBHNTAe
# Fw0xMzEyMTAwMDAwMDBaFw0yMzEyMDkyMzU5NTlaMH8xCzAJBgNVBAYTAlVTMR0w
# GwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMWU3ltYW50ZWMg
# VHJ1c3QgTmV0d29yazEwMC4GA1UEAxMnU3ltYW50ZWMgQ2xhc3MgMyBTSEEyNTYg
# Q29kZSBTaWduaW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
# l4MeABavLLHSCMTXaJNRYB5x9uJHtNtYTSNiarS/WhtR96MNGHdou9g2qy8hUNqe
# 8+dfJ04LwpfICXCTqdpcDU6kDZGgtOwUzpFyVC7Oo9tE6VIbP0E8ykrkqsDoOatT
# zCHQzM9/m+bCzFhqghXuPTbPHMWXBySO8Xu+MS09bty1mUKfS2GVXxxw7hd924vl
# YYl4x2gbrxF4GpiuxFVHU9mzMtahDkZAxZeSitFTp5lbhTVX0+qTYmEgCscwdyQR
# TWKDtrp7aIIx7mXK3/nVjbI13Iwrb2pyXGCEnPIMlF7AVlIASMzT+KV93i/XE+Q4
# qITVRrgThsIbnepaON2b2wIDAQABo4IBgzCCAX8wLwYIKwYBBQUHAQEEIzAhMB8G
# CCsGAQUFBzABhhNodHRwOi8vczIuc3ltY2IuY29tMBIGA1UdEwEB/wQIMAYBAf8C
# AQAwbAYDVR0gBGUwYzBhBgtghkgBhvhFAQcXAzBSMCYGCCsGAQUFBwIBFhpodHRw
# Oi8vd3d3LnN5bWF1dGguY29tL2NwczAoBggrBgEFBQcCAjAcGhpodHRwOi8vd3d3
# LnN5bWF1dGguY29tL3JwYTAwBgNVHR8EKTAnMCWgI6Ahhh9odHRwOi8vczEuc3lt
# Y2IuY29tL3BjYTMtZzUuY3JsMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcD
# AzAOBgNVHQ8BAf8EBAMCAQYwKQYDVR0RBCIwIKQeMBwxGjAYBgNVBAMTEVN5bWFu
# dGVjUEtJLTEtNTY3MB0GA1UdDgQWBBSWO1PweTOXr32D7y4rzMq3hh5yZjAfBgNV
# HSMEGDAWgBR/02Wnwt3su/AwCfNDOfoCrzMxMzANBgkqhkiG9w0BAQsFAAOCAQEA
# E4UaHmmpN/egvaSvfh1hU/6djF4MpnUeeBcj3f3sGgNVOftxlcdlWqeOMNJEWmHb
# cG/aIQXCLnO6SfHRk/5dyc1eA+CJnj90Htf3OIup1s+7NS8zWKiSVtHITTuC5nmE
# FvwosLFH8x2iPu6H2aZ/pFalP62ELinefLyoqqM9BAHqupOiDlAiKRdMh+Q6EV/W
# pCWJmwVrL7TJAUwnewusGQUioGAVP9rJ+01Mj/tyZ3f9J5THujUOiEn+jf0or0oS
# vQ2zlwXeRAwV+jYrA9zBUAHxoRFdFOXivSdLVL4rhF4PpsN0BQrvl8OJIrEfd/O9
# zUPU8UypP7WLhK9k8tAUITGCBEQwggRAAgEBMIGTMH8xCzAJBgNVBAYTAlVTMR0w
# GwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMWU3ltYW50ZWMg
# VHJ1c3QgTmV0d29yazEwMC4GA1UEAxMnU3ltYW50ZWMgQ2xhc3MgMyBTSEEyNTYg
# Q29kZSBTaWduaW5nIENBAhASn/W83LmZkqPf6+aeK2mOMAkGBSsOAwIaBQCgeDAY
# BgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3
# AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEW
# BBT80Kk+BzXT4jN32sIBPHewmTChuTANBgkqhkiG9w0BAQEFAASCAQANBsJ4xGWb
# Fa2/BDggJS8mgJWg/3Sf4zTaRROrOl5q7Bo+knx7BTIb5aOIbxARc/i+JR/drylG
# A98EFzFuQG9LHnOk8tNl6Hkfl2FBQr0UT8S1tYDz4Nqj2og3bbo3nnblgSdJtApd
# 4h5acYz2MkfPVzQlGnqrpL0hOP+2YvEkAQRekedkT669PltBQH/Cq6ysdqVbaWsW
# BbGn/mai+sW3mPqPupC8E0kTv/+535qqXQLX1BP37RgLVcMVOnOWf5/AjAIq9p+k
# RkPQrjLLsXODXdgxtUJiBYaFFfNkr3UH+//R0MQspweyDrrxt70pBc0NYtwzKrus
# xn2q0uL+9O6ioYICCzCCAgcGCSqGSIb3DQEJBjGCAfgwggH0AgEBMHIwXjELMAkG
# A1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMTAwLgYDVQQD
# EydTeW1hbnRlYyBUaW1lIFN0YW1waW5nIFNlcnZpY2VzIENBIC0gRzICEA7P9DjI
# /r81bgTYapgbGlAwCQYFKw4DAhoFAKBdMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0B
# BwEwHAYJKoZIhvcNAQkFMQ8XDTE2MDYwMzA4MjIxOFowIwYJKoZIhvcNAQkEMRYE
# FArBtnCiEweFpUtL0eXfMapUsh1eMA0GCSqGSIb3DQEBAQUABIIBAGRdRM573FUy
# XoTnErEltxrM+7a038hkctaW5b/bYbf3I1LCXnT5BLdJA7AT7Z0xTEadEYJj0YsW
# l6Cd18xdYNTdyjQvke/Mvn7/ze/AmFSgabDAdP2IHKUKqmIoPCQM/2TeX/oZGENW
# yBvIHeuo697UckX//b2blfHE5Ea1PiKd2WQ+TYt3GejmY3OebhXrFeS+Q8oVBoH0
# 6yW40At3JqkBAZ+VX7gnmIEMCPnDw3Fs1w/cFGLXj7zYVAN/5NF619YWuHjUcWoe
# plAP8Ju6cXd0f3ykXi9+fDk2zRuOOYfuRWm0rljdruYvGAc3qXx9+eDS+7Ktt07m
# WWZT8Q5sAyA=
# SIG # End signature block
