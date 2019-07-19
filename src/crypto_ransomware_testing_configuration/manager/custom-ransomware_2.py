#!/usr/bin/env python2.7

import sys,json,os

# Read configuration parameters
alert_file = open(sys.argv[1])

# Read the alert file
alert_json = json.loads(alert_file.read())
alert_file.close()

# Extract fields
alert_id=alert_json['rule']['id']
if alert_id == '333019':
    full_log=alert_json['full_log']
    exe=full_log.split("Process name: '")[1].split("'\n")[0].replace("\\","/")
elif alert_id == '62103' or alert_id == '62104':
    exe=alert_json['description'].split("unwanted software ")[1].split("\"")[0].replace("\\","/")
else:
    exit(1)

# Execute the command and call the script with ssh
exe_short=exe.split("/")[-1]
exe_short_noexe=exe_short.split(".")[0]
os.system("ssh Administrator@10.0.3.2 'powershell (Stop-Process -Name "+exe+" -PassThru -Force) -or (Stop-Process -Name "+exe_short_noexe+" -PassThru -Force) -or (Stop-Process -Name "+exe_short+" -Force)' 2>&1 &")
