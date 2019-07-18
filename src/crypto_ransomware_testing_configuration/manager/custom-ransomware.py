#!/usr/bin/env python2.7

import sys,json,os,datetime,subprocess

# Read configuration parameters
alert_file = open(sys.argv[1])

# Read the alert file
alert_json = json.loads(alert_file.read())
alert_file.close()

# Extract fields
alert_id=alert_json['rule']['id']
options=""
if alert_id == '333019':
    directory=alert_json['syscheck']['path'].replace("\\","/").rsplit('/',1)[0]
    full_log=alert_json['full_log']
    pid=full_log.split("Process id: '")[1].split("'\n")[0]
    exe=full_log.split("Process name: '")[1].split("'\n")[0].replace("\\","/")
    options=1
# elif alert_id == '333202':
    # full_log=alert_json['full_log']
    # directory=full_log.split("scanned_filename\":\"")[1].split("\",")[0].replace("\\","/").rsplit('/',1)[0]
    # pid=""
    # exe=""
# elif alert_id == '333050':
    # full_log=alert_json['full_log']
    # directory="unknown"
    # pid="0"
    # exe=full_log.split("\"message\":\"")[1].split("has been")[0].replace("\\","/")
    # options=1
elif alert_id == '62103' or alert_id == '62104':
    directory="unknown"
    pid="0"
    exe=alert_json['description'].split("unwanted software ")[1].split("\"")[0].replace("\\","/")
    options=1
else:
    exit(1)

# Execute the command and call the script with ssh
#same speed as os.system("ssh Administrator@10.0.3.2 'powershell C:/Program` Files` `(x86`)/ossec-agent/active-response/bin/stop.ps1' "+directory+" "+pid+" "+exe+" "+options" 2>&1 &")
output=subprocess.check_output("ssh Administrator@10.0.3.2 'powershell C:/Program` Files` `(x86`)/ossec-agent/active-response/bin/stop.ps1' "+directory+" "+pid+" "+exe+" "+options+" 2>&1", shell=True)
LOG="/tmp/wazuh-ssh-script-ransomware_"+alert_id
with open(LOG, 'a') as f:
    f.write("\n\n"+datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')+"\n"+output)
