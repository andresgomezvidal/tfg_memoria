Remove-ItemProperty -path HKLM:"\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet\" -Name 'SpyNetReporting'
Remove-ItemProperty -path HKLM:"\SOFTWARE\Policies\Microsoft\Windows Defender\" -Name 'DisableAntiSpyware'
Remove-ItemProperty -path HKLM:"\SOFTWARE\Policies\Microsoft\Windows Defender\" -Name 'DisableBehaviorMonitoring'
Remove-ItemProperty -path HKLM:"\SOFTWARE\Policies\Microsoft\Windows Defender\" -Name 'DisableOnAccessProtection'
Remove-ItemProperty -path HKLM:"\SOFTWARE\Policies\Microsoft\Windows Defender\" -Name 'DisableScanOnRealtimeEnable'
