#!/bin/python3

import sys, os
import subprocess
from pprint import pprint
import yaml

ffr_config_filename = sys.argv[1]
print(ffr_config_filename)

with open(ffr_config_filename) as f:
    config = yaml.safe_load(f.read())

# Cerate runcom files
ws=config['ws_dir']

# Comments
"""
Every bash instance will reference the clear workspace and the generic stuff that should apply to everything.

When an instance is launched, it will point to a .ffr_rc file which says where the tmux panes should additionally point to.

The ROS_DOMAIN_ID should come form the config, so it should be accessible from the generic runcom.

The FIELD_NAME is specific to the launch so will be included in the specific one.

The environment.sh path is accessible relative to the rospkg prefix so can be identified after the field workspace is sourced.

The MQTT information should not be defined in the config and should instead require manual intervention.



"""

home = "/home/james"
bashrc_filepath = f"{home}/.bashrc"

# FFR config stores
ffr_selector_filepath = f"{home}/active_ffr_group.sh"
workspace_selector_filepath = f"{ws}/configuration/active_ffr_ws.sh"

# General Config Scripts
general_runcom_filepath = f"{ws}/configuration/scripts/general_runcom.sh"

# Field Config Scripts
instance_runcom_filepath = f"{ws}/configuration/scripts/instance.sh"
environment_sourcer_runcom_filepath = f"{ws}/configuration/scripts/environment_sourcer.sh"
ros_domain_ids_runcom_filepath = f"{ws}/configuration/scripts/ros_domain_ids.sh"
networks_runcom_filepath = f"{ws}/configuration/scripts/networks.sh"

# Construct directories
if not os.path.exists(f"{ws}/configuration/scripts"):
    os.makedirs(f"{ws}/configuration/scripts")
print('\n'*10)


# Add to ~/.bashrc
print("")
print(f"Writing to: {bashrc_filepath}")
with open(bashrc_filepath, 'a') as f:
    f.write("")
    f.write("# Source the FFR specialist runcom\n")
    f.write(f"source {ffr_selector_filepath}\n")
    f.write("")


# Add to ~/active_ffr_group
print("")
print(f"Wrtiing to: {ffr_selector_filepath}")
with open(ffr_selector_filepath, 'w+') as f:
    f.write("# -- temp file --\n")
    f.write("# This file was written by the ffr_installer.\n")
    f.write("# This file may be overritten.\n")
    f.write("# This file sources the active ffr group.\n")
    f.write("\n")
    f.write(f"export FFR_ACTIVE_WORKSPACE_GROUP={ws}\n")
    f.write(f"source {general_runcom_filepath}\n")
    f.write("\n")


# Add to general runcom file
print("")
print(f"Wrtiing to: {general_runcom_filepath}")
with open(general_runcom_filepath, 'w+') as f:
    f.write("\n")
    f.write("# Reset ROS package awarenesses\n")
    f.write("export PYTHONPATH=\n")
    f.write("export AMENT_PREFIX_PATH=\n")
    f.write("export CMAKE_PREFIX_PATH=\n")
    f.write("export COLCON_PREFIX_PATH=\n")
    f.write("echo '| Resetting ROS sourcing'")
    f.write("source /opt/ros/humble/setup.bash\n")
    f.write("echo '| Sourcing /opt/ros/humble'")
    f.write("\n")
    f.write("# Source the shared workspace\n")
    f.write(f"source {ws}/shared_ws/install/setup.bash\n")
    f.write("echo '| Sourcing shared_ws'")
    f.write("\n")


# Sourced by TMuLe's init_cmd
print("")
print(f"Wrtiing to: {workspace_selector_filepath}")
with open(workspace_selector_filepath, 'w+') as f:
    f.write("# -- temp file --\n")
    f.write("# This file was written by the ffr_tmule_manager.\n")
    f.write("# This file may be overritten.\n")
    f.write("# This file sources the active ffr workspace.\n")
    f.write("\n")
    f.write("# Source to get the specified field\n")
    f.write("export FFR_ACTIVE_WS=\n")
    f.write("export FFR_ACTIVE_WS_NAME=\n")
    f.write("\n")


# Sourced by TMuLe's init_cmd
print("")
print(f"Wrtiing to: {instance_runcom_filepath}")
with open(instance_runcom_filepath, 'w+') as f:
    f.write("\n")
    f.write("# Source the workspace selector to get the specified field\n")
    f.write("source $FFR_ACTIVE_WORKSPACE_GROUP/configuration/active_ffr_ws.sh\n")
    f.write('echo "Working in: $FFR_ACTIVE_WS"\n')
    f.write('echo "Working in ffr location: $FFR_ACTIVE_WS_NAME"\n')
    f.write("\n")
    f.write("# Source the instance's workspace\n")
    f.write("source $FFR_ACTIVE_WS/install/setup.bash\n")
    f.write("\n")
    f.write("# Source the ENVIRONMENTS runcom file\n")
    f.write("source $FFR_ACTIVE_WORKSPACE_GROUP/configuration/scripts/environment_sourcer.sh\n")
    f.write("\n")
    f.write("# Source the ROS_DOMAIN_ID runcom file\n")
    f.write("source $FFR_ACTIVE_WORKSPACE_GROUP/configuration/scripts/ros_domain_ids.sh\n")
    f.write("\n")
    f.write("# Source the network runcom file\n")
    f.write("source $FFR_ACTIVE_WORKSPACE_GROUP/configuration/scripts/networks.sh\n")
    f.write("\n")


# Add process to get environment.sh sourced
print("")
print(f"Wrtiing to: {environment_sourcer_runcom_filepath}")
with open(environment_sourcer_runcom_filepath, 'w+') as f:
    f.write("""
      # Source environment configuration
      PKG_LIST=$(ros2 pkg list)
      SEARCH="environment_template"
      ENVPATH="config/environment.sh"
      if [[ "$PKG_LIST" == *"$SEARCH"* ]]; then
          export ROS_ENV_TEMPLATE=$(ros2 pkg prefix $SEARCH)/share/$SEARCH
          [ -f $ROS_ENV_TEMPLATE/$ENVPATH ] && source $ROS_ENV_TEMPLATE/$ENVPATH
      fi
      echo $FIELD_NAME
      #FARM_NAME
      #FIELD_NAME, FIELD_TYPE
      #TMAP_FILE, DATUM_FILE
    """)


# Add to the ros_domain_ids specialised runcom
print("")
print(f"Wrtiing to: {ros_domain_ids_runcom_filepath}")
with open(ros_domain_ids_runcom_filepath, 'w+') as f:

    # Set default domain id
    f.write("\n")
    f.write("## Set default domain id\n")
    f.write("export ROS_DOMAIN_ID=200\n")
    f.write("\n")

    # Add condition to switch block for the farm's domain id
    ws_name = config['farm']['ws_name']
    domain_id = config['farm']['ros_domain_id']
    f.write(f"## {ws_name}\n")
    f.write(f'if [ "$FFR_ACTIVE_WS_PATH" == "{ws_name}" ]\n')
    f.write("then\n")
    f.write(f"    export ROS_DOMAIN_ID={domain_id};\n")
    f.write("\n")

    # Loop through each field in the config
    for i, field in enumerate(config['fields']):

        # Identify properties
        ws_name = field['ws_name']
        domain_id = field['ros_domain_id']

        # Write to specialised runcom
        f.write(f"## {ws_name}\n")
        f.write(f'elif [ "$FFR_ACTIVE_WS_PATH" == "fields/{ws_name}" ]\n')
        f.write("then\n")
        f.write(f"    export ROS_DOMAIN_ID={domain_id};\n")
        f.write("\n")

    # Finalise switch block
    f.write("## if field not specified, trigger ROS error\n")
    f.write("else\n")
    f.write("    export ROS_DOMAIN_ID=233\n")
    f.write("fi\n")
    f.write("\n")


# Add process to get network information
print("")
print(f"Wrtiing to: {networks_runcom_filepath}")
with open(networks_runcom_filepath, 'w+') as f:
    f.write("\n")

    f.write("# Notify user that this file needs to be filled\n")
    f.write("echo 'Network runcom needs to be filled by hand.'\n")
    f.write(f"echo 'Filepath: {networks_runcom_filepath}'\n")

    # Add condition to switch block for the farm's domain id
    name = config['farm']['name']
    ws_name = config['farm']['ws_name']
    domain_id = config['farm']['ros_domain_id']

    f.write("\n")
    f.write(f"export FARM_MQTT_IP=\n")
    f.write(f"export FARM_MQTT_PORT=\n")
    f.write(f"export FARM_MQTT_NAMESPACE=\n")

    f.write("\n")
    f.write(f"## {name}\n")
    f.write(f'if [ "$FFR_ACTIVE_WS_PATH" == "{ws_name}" ]\n')
    f.write("then\n")
    f.write("    export FIELD_MQTT_IP=\n")
    f.write("    export FIELD_MQTT_PORT=\n")
    f.write(f"    export FIELD_MQTT_NAMESPACE={name}/{ws_name}\n")
    f.write("\n")

    # Loop through each field in the config
    for i, field in enumerate(config['fields']):

        # Identify properties
        ws_name = field['ws_name']
        domain_id = field['ros_domain_id']

        # Write to specialised runcom
        f.write(f"## {ws_name}\n")
        f.write(f'elif [ "$FFR_ACTIVE_WS_PATH" == "fields/{ws_name}" ]\n')
        f.write("then\n")
        f.write("    export FIELD_MQTT_IP=\n")
        f.write("    export FIELD_MQTT_PORT=\n")
        f.write(f"    export FIELD_MQTT_NAMESPACE={name}/{ws_name}\n")
        f.write("\n")

    # Finalise switch block
    f.write("## if field not specified, trigger MQTT error\n")
    f.write("else\n")
    f.write("    export FIELD_MQTT_IP=\n")
    f.write("    export FIELD_MQTT_PORT=\n")
    f.write("    export FIELD_MQTT_NAMESPACE=\n")
    f.write("fi\n")
    f.write("\n")

