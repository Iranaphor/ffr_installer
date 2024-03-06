export WS_DIR=~/ros2_riseholme_park_fields


# Identify Farm TMuLe
export FFR_FARM_SHARE=$WS_DIR/shared_ws/install/ffr_farm/share/ffr_farm
export farmTm=$FFR_FARM_SHARE/tmule/farm_example.tmule.yaml


# Identify Field TMuLe
export FFR_FIELD_SHARE=$WS_DIR/shared_ws/install/ffr_ield/share/ffr_field
export fieldTm=$FFR_SHARE/tmule/field_example.tmule.yaml


# Define TMuLe launch functions
function rename () { tmux rename-session -t field_1_example $1 ; }
function set_source () {
    echo 'source $WS_DIR/$1/install/setup.bash' > ~/.field_source ;
}
function farm () { set_source farm_ws ; tmule -c $farmTm $1 ; }
function field () { set_source $1_ws ; tmule -c $fieldTm $2 ; rename $1 ; }


# Whiptail TMuLe Dialogue
ros2 run ffr_field manage
    - tmule
        - field_example_*.tmule.yaml
            - launch
            - terminate
example.tmule.yaml launch

