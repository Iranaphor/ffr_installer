#!/bin/python3

import sys, os
import subprocess
from pprint import pprint
import yaml

filename = sys.argv[1]
print(filename)

with open(filename) as f:
    config = yaml.safe_load(f.read())

pprint(config)
print(config.keys())


# Create root workspace
ws=config['ws_dir']
os.makedirs(ws, exist_ok=True)
os.chdir(ws)


# Construct Shared Workpsace
shared_ws = ws+'/'+config['shared']['ws_name']+'/src/'
os.makedirs(shared_ws, exist_ok=True)
os.chdir(shared_ws)
repositories=config['shared']['repositories']
for repo in repositories:
    subprocess.check_output(["git", "clone", repo['url'], "-b", repo['branch']], text=True)


# Make farm workspace
farm_ws   = ws+'/'+config['farm']['ws_name']+'/src/'
os.makedirs(farm_ws, exist_ok=True)
os.chdir(farm_ws)
repositories=config['farm']['repositories']
for repo in repositories:
    subprocess.check_output(["git", "clone", repo['url'], "-b", repo['branch']], text=True)


# Make field workspaces
fields_ws = ws+'/'+'fields'
os.makedirs(fields_ws, exist_ok=True)
for field in config['fields']:
    os.makedirs(fields_ws+'/'+field['ws_name'], exist_ok=True)
    os.chdir(fields_ws+'/'+field['ws_name'])
    repositories=field['repositories']
    for repo in repositories:
        subprocess.check_output(["git", "clone", repo['url'], "-b", repo['branch']], text=True)

