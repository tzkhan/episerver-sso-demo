param($installPath, $toolsPath, $package, $project)

$fxPackage = Get-package | where-object { $_.id -eq "EPiServer.Framework"} | Sort-Object -Property Version -Descending | select-object -first 1
$cmsPackage = Get-package | where-object { $_.id -eq "EPiServer.Core"} | Sort-Object -Property Version -Descending| select-object -first 1
$fxTools =[System.IO.Path]::Combine( $installPath,  ".." , $fxPackage.Id + "." + $fxPackage.Version , "tools")
$cmsConfigBaselinePath =[System.IO.Path]::Combine($installPath, "tools\webconfig-baseline.config")
$sitePath = (Get-ChildItem $project.Fullname).Directory.FullName

## Call assembly redirects
$ScriptPath = $MyInvocation.MyCommand.Path
$ScriptDir  = Split-Path -Parent $ScriptPath
& (Join-Path $ScriptDir 'AssemblyRedirects.ps1') -installPath $installPath -toolsPath $toolsPath -package $package -project $project

$epideployPath = Join-Path $fxTools 'epideploy.exe'

## Install baseline if not already added
$webConfigPath = Join-Path $sitePath "web.config"
if (Test-Path $webConfigPath) 
{
	$webConfig = New-Object xml
	$webConfig.Load($webConfigPath)
	if($webConfig.configuration.episerver -eq $null)
	{
		Write-Host "Adding CMS baseline configuration"
		& $epideployPath -s $sitePath -a config -p $cmsConfigBaselinePath
	}
	
	## Run upgrades
	$cmsUpgradePath =[System.IO.Path]::Combine($installPath, "tools\epiupdates\**\*.config")
	& $epideployPath -s $sitePath -a config -p $cmsUpgradePath
}
# SIG # Begin signature block
# MIIXpAYJKoZIhvcNAQcCoIIXlTCCF5ECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUENLeveZRP2wnBNT8PMqsSfVz
# 9QegghLKMIID7jCCA1egAwIBAgIQfpPr+3zGTlnqS5p31Ab8OzANBgkqhkiG9w0B
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
# BBR/ruCl8zT0bfYxb2ht0GieVWhX+TANBgkqhkiG9w0BAQEFAASCAQCVn8KSQIUJ
# vDVS3wdo/+i36ahDkJY/thlBaiQoUtBeDM837jCeJJwWfcRG/w6aQm61GFvvi+mr
# oaveyNTbmGk+Q1DJOCPdgOV6p1vDgLu/rVcIICmSr2RsG7LuhOZsobylCpRHXDMh
# sD9T6P7xzaAFBQkshsQBOi5SyFlh8jX8KlARa4Rdemgr1jbe9m8d012B20cmf6Qo
# x8bkVkmQ104XFojiyzWH11e7d9Nr+dWLsamY9rLapqXH4MBhNpD46a7ZQseR70f0
# NAGYMfhCCg9X7Qu3jPNA7W2x7S6IFNPIB9LwYo6dHUpY8Wq56MCp59FotVlDeWYL
# Y72iTp/dA07aoYICCzCCAgcGCSqGSIb3DQEJBjGCAfgwggH0AgEBMHIwXjELMAkG
# A1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMTAwLgYDVQQD
# EydTeW1hbnRlYyBUaW1lIFN0YW1waW5nIFNlcnZpY2VzIENBIC0gRzICEA7P9DjI
# /r81bgTYapgbGlAwCQYFKw4DAhoFAKBdMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0B
# BwEwHAYJKoZIhvcNAQkFMQ8XDTE2MDUwNjA1NTUzM1owIwYJKoZIhvcNAQkEMRYE
# FHAv+wYO+HgMIQcaNvpU7q+m4zGFMA0GCSqGSIb3DQEBAQUABIIBAExmwO2AIxD6
# Y56DnbDd30UIDDBCfOp1Hhbu9LKOEXV27nBHYHut+lZSgM84+cairOO7+ZKr7ny3
# 89a0w6gTxuvqMqxPFOSZBSho8MJKznfGQY8zVvL8Qa8Z7hyXYFlRMTNQNXypjSd/
# 8pTAu8YeqpnJ3z84Ll0Sb1JE7HCzH3wSaBCRyziwDTsCpltqlDqvrMW8pcQMXwuT
# WY4gjQ23ZC6EHCP5rn1ZPWPv0/+rjP8l2INAGNJETYnCg78LgVhT/vQAjwW7PH93
# E6qnZ0TDfAYDmwSZnkS6XoNH9O/6lQz5cGG++kE4BSPDWtGB+Fv9TkBIGq4D6bKW
# MrJBdkwF1MQ=
# SIG # End signature block
