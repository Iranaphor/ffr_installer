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
shared_ws = ws+'/'+config['shared']['ws_name']
os.makedirs(shared_ws+'/src/', exist_ok=True)
os.chdir(shared_ws+'/src/')
repositories=config['shared']['repositories']
for repo in repositories:
    subprocess.check_output(["git", "clone", repo['url'], "-b", repo['branch']], text=True)
os.chdir(shared_ws)
subprocess.check_output(["colcon", "build", "--symlink-install"], text=True)


# Make farm workspace
farm_ws = ws+'/'+config['farm']['ws_name']
os.makedirs(farm_ws+'/src/', exist_ok=True)
os.chdir(farm_ws+'/src/')
repositories=config['farm']['repositories']
for repo in repositories:
    subprocess.check_output(["git", "clone", repo['url'], "-b", repo['branch']], text=True)
os.chdir(farm_ws)
subprocess.check_output(["colcon", "build", "--symlink-install"], text=True)


# Make field workspaces
fields_ws = ws+'/'+'fields'
os.makedirs(fields_ws, exist_ok=True)
for field in config['fields']:
    os.makedirs(fields_ws+'/'+field['ws_name']+'/src/', exist_ok=True)
    os.chdir(fields_ws+'/'+field['ws_name']+'/src/')
    repositories=field['repositories']
    for repo in repositories:
        subprocess.check_output(["git", "clone", repo['url'], "-b", repo['branch']], text=True)
    os.chdir(fields_ws+'/'+field['ws_name'])
    subprocess.check_output(["colcon", "build", "--symlink-install"], text=True)
