#!/usr/bin/env python2.7

import sys,json,os

# Read configuration parameters
alert_file = open(sys.argv[1])

# Read the alert file
alert_json = json.loads(alert_file.read())
alert_file.close()

# Extract fields call the script
alert_id=alert_json['rule']['id']
if alert_id == '333015' or alert_id == '333016':
    directory=alert_json['syscheck']['path'].replace("\\","/").rsplit('/',1)[0]
    # full_log=alert_json['full_log']
    # pid=full_log.split("Process id: '")[1].split("'\n")[0]
    # exe=full_log.split("Process name: '")[1].split("'\n")[0].replace("\\","/")
    # os.system("ssh Administrator@10.0.3.2 'powershell \"C:/Program Files (x86)/ossec-agent/active-response/bin/trid.ps1\"' "+directory+" "+pid+" "+exe)
    #TODO comprobar que funciona
    os.system("ssh Administrator@10.0.3.2 'powershell \"C:/Program Files (x86)/ossec-agent/active-response/bin/trid.ps1\"' "+directory)
else:
    exit(1)
