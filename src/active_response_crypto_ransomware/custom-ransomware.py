#!/usr/bin/env python2.7

import sys,json,os

# Read configuration parameters
alert_file = open(sys.argv[1])

# Read the alert file
alert_json = json.loads(alert_file.read())
alert_file.close()

# Extract fields and call the script
alert_id=alert_json['rule']['id']
if alert_id == '333019':
    directory=alert_json['syscheck']['path'].replace("\\","/").rsplit('/',1)[0]
    full_log=alert_json['full_log']
    pid=full_log.split("Process id: '")[1].split("'\n")[0]
    exe=full_log.split("Process name: '")[1].split("'\n")[0].replace("\\","/")
    os.system("ssh Administrator@10.0.3.2 'powershell C:\Users\Administrator\Downloads\stop.ps1' "+directory+" "+pid+" "+exe)
elif alert_id == '333202':
    full_log=alert_json['full_log']
    directory=full_log.split("scanned_filename\":\"")[1].split("\",")[0].replace("\\","/").rsplit('/',1)[0]
    os.system("ssh Administrator@10.0.3.2 'powershell C:\Users\Administrator\Downloads\stop.ps1' "+directory)
else:
    exit(1)
