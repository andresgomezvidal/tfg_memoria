For ($i = 0; $i -le 3; $i+=1) {
	winrs -r:WIN-25U0PFAB511.wazuh.local -u:Administrator -p:'Password?' whoami
	winrs -r:WIN-25U0PFAB511.wazuh.local -u:fserver -p:'Password?' whoami
	winrs -r:WIN-25U0PFAB511.wazuh.local -u:w10 -p:'Password?' whoami
}
