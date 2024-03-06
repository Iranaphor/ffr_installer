# ffr_installer

To construct the worspaces take the following steps in your terminal:
```
$ . manage.sh
$ construct_ffr_workspaces

Select a control category:
    [0] Install
    [1] Git
    [2] TMuLe
# 
```

To install the workspaces based on a config file, ensure the config is located in theconfigs folder, type 0, and click ENTER.
```
Option [0]; Install selected.

Select an install configuration:
[1] ./configs/indoor_experiment_1.conf.yaml
[2] ./configs/riseholme_park_farm_fields.conf.yaml
# 
```

This now gives you the option to sleect which configuration file to use. 
Type the respective number and click ENTER.

The script will construct each workspace and for each repository if it is private,
it will request the username and github token as password.

It will then add the required functinality to your ~/.bacshrc file.
