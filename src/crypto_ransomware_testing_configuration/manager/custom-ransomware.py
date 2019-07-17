#!/usr/bin/env python2.7

import sys,json,os,datetime,subprocess

# Read configuration parameters
alert_file = open(sys.argv[1])

# Read the alert file
alert_json = json.loads(alert_file.read())
alert_file.close()

# Extract fields
alert_id=alert_json['rule']['id']
if alert_id == '333019':
    directory=alert_json['syscheck']['path'].replace("\\","/").rsplit('/',1)[0]
    full_log=alert_json['full_log']
    pid=full_log.split("Process id: '")[1].split("'\n")[0]
    exe=full_log.split("Process name: '")[1].split("'\n")[0].replace("\\","/")
elif alert_id == '333202':
    full_log=alert_json['full_log']
    directory=full_log.split("scanned_filename\":\"")[1].split("\",")[0].replace("\\","/").rsplit('/',1)[0]
    pid=""
    exe=""
else:
    exit(1)

# Execute the command and call the script with ssh
output=subprocess.check_output("ssh Administrator@10.0.3.2 'powershell C:/Program` Files` `(x86`)/ossec-agent/active-response/bin/stop.ps1' "+directory+" "+pid+" "+exe+" 2>&1 &", shell=True)
LOG="/tmp/wazuh-ssh-script-ransomware_"+alert_id
with open(LOG, 'a') as f:
    f.write("\n\n"+datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')+"\n"+output)
