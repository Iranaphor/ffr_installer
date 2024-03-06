#!/bin/python3

import sys, os
import subprocess
from pprint import pprint
import yaml

filename = sys.argv[1]
print(filename)

with open(filename) as f:
    config = yaml.safe_load(f.read())

def check_status(conf, src):
    print('-------------------------------')
    print(conf['ws_name'])
    _repositories=conf['repositories']
    for _repo in _repositories:
        _dir = _repo['url'].split('/')[-1]
        os.chdir(src+_dir)
        print('> ', _dir, '\n')
        print(subprocess.check_output(["git", "status",  "|", "grep", '"On\|Your"'], text=True))
        print(subprocess.check_output(["git", "status",  "-s"], text=True))

# Identify principle workspace
ws=config['ws_dir']

#Check status repositories in each workspace defined in the config
check_status(config['shared'], ws+'/'+config['shared']['ws_name']+'/src/')
check_status(config['farm'], ws+'/'+config['farm']['ws_name']+'/src/')
for field in config['fields']:
    check_status(field, ws+'/fields/'+field['ws_name']+'/src/')
