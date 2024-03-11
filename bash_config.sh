###############################################################
#in tmule

# The bashrc:
#   | sources ~/active_ffr_group.sh
#       | gets $FFR_WORKSPACE_ROOT
#       | and sources $FFR_WORKSPACE_GROUP/configuration/general_runcom.sh
#           | resets ROS paths
#           | sources /opt/ros/humble
#           | sources $FFR_WORKSPACE_GROUP/shared_ws/install/setup.bash

# Source the ws_selector, to auto-source the instance to set field info
#   | sources $FFR_WORKSPACE_GROUP/configuration/active_ffr_ws.sh
#       | gets $FFR_ACTIVE_WS
#   | sources $FFR_ACTIVE_WS/install/setup.bash
#   | sources $FFR_WORKSPACE_GROUP/configuration/environment_sourcer.sh
#   | sources $FFR_WORKSPACE_GROUP/configuration/ros_domain_ids.sh
#   | sources $FFR_WORKSPACE_GROUP/configuration/networks.sh


source $FFR_WORKSPACE_GROUP/configuration/scripts/instance.sh



###############################################################
#in tmule

  source /opt/ros/humble/setup.bash
  source $ws/shared_ws/install/setup.bash

  # Include this ws contents (only for this field)
  source ~/.field_source # This is set in the runcom at tmule launch

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

  # Source farm information and sensitive field information
  [ -f $HOME/.fieldrc ] && source $HOME/.fieldrc
  #FARM_IP,  FARM_MQTT_BROKER_PORT,  FARM_MQTT_NS
  #FIELD_IP FIELD_MQTT_BROKER_PORT, FIELD_MQTT_NS




###############################################################
#in fieldrc



#! /bin/bash

# SET FARM VALUES
#export FARM_IP='0.0.0.0'
#export FARM_MQTT_BROKER_PORT='8886'
#export FARM_MQTT_NS="$FARM_NAME"
[ -f $HOME/.farmrc ] && source $HOME/.farmrc


# SET DEFAULT FIELD VALUES
export FIELD_IP='0.0.0.0'
export FIELD_MQTT_BROKER_PORT='8884'
export FIELD_MQTT_NS="$FIELD_NAME"



echo "FIELD ENVIRONMENT VARIABLES SET"
echo "    export FIELD_IP=$FIELD_IP"
echo "    export FIELD_MQTT_BROKER_PORT=$FIELD_MQTT_BROKER_PORT"
echo "    export FIELD_MQTT_NS=$FIELD_MQTT_NS"
echo "    export ROS_DOMAIN_ID=$ROS_DOMAIN_ID"
echo ""
echo "IMPORTANT:"
echo "Ensure you rename the field session before launching a second field."
echo "    'tmux rename-session -t field_1_example $FARM_NAME_$FIELD_NAME'"
echo ""



################################################################
# in farmrc

#! /bin/bash

# SET FARM IFORMATION
export FARM_NAME='riseholme_park'
export FARM_DATUM_LATITUDE='53.268617'
export FARM_DATUM_LONGITUDE='-0.525699'

# SET FARM VALUES
export FARM_IP='0.0.0.0'
export FARM_MQTT_BROKER_PORT='8886'
export FARM_MQTT_NS=$FARM_NAME

# SET DEFAULT ROS VALUES
export ROS_DOMAIN_ID=200


echo ""
echo "FARM ENVIRONMENT VARIABLES SET"
echo "    export FARM_IP=$FARM_IP"
echo "    export FARM_MQTT_BROKER_PORT=$FARM_MQTT_BROKER_PORT"
echo "    export FARM_MQTT_NS=$FARM_MQTT_NS"
echo "    export ROS_DOMAIN_ID=$ROS_DOMAIN_ID"
echo ""






