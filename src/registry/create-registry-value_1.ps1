New-ItemProperty -path HKLM:"\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access\" -Name 'EnableControlledFolderAccess' -Value "0x00000001" -PropertyType "Dword"
New-ItemProperty -path HKLM:"\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access\" -Name 'ExploitGuard_ControlledFolderAccess_AllowedApplications' -Value "0x00000001" -PropertyType "Dword"
New-ItemProperty -path HKLM:"\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access\" -Name 'ExploitGuard_ControlledFolderAccess_ProtectedFolders' -Value "0x00000001" -PropertyType "Dword"