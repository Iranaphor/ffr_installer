source ./git.sh
source ./ffr.sh

##########
# This script is to control the FFR workspaces.
# It has three pirimary uses; installing, updating, and running.
##########

export option1=''
export option2=''

function ffr_control () {

    if [ -n "$1" ]; then export option_0=$1; else export option_0=''; fi
    if [ -n "$2" ]; then export option_1=$2; else export option_1=''; fi
    if [ -n "$3" ]; then export option_1_0=$3; else export option_1_0=''; fi
    if [ -n "$3" ]; then export option_1_1=$3; else export option_1_1=''; fi
    if [ -n "$4" ]; then export option_1_1_0=$4; else export option_1_1_0=''; fi
    if [ -n "$4" ]; then export option_1_1_1=$4; else export option_1_1_1=''; fi
    if [ -n "$5" ]; then export option_1_1_0_0=$5; else export option_1_1_0_0=''; fi

    #clear

    # Save a config file name to $selected_config
    opt_0config

    # Select what to do with configuration
    opt_1control
}

function opt_0config() {
    source ./ffr.sh
    configs=$(get_configs)
    if [ -z "$option_0" ]; then
        echo "Select an install configuration:"
        i=1
        for config in $configs
        do
            echo [$i] $config
            i=$(($i+1))
        done
        read -p "# " option_0
    fi

    export selected_config=$(echo $configs | cut -d ' ' -f $option_0)
    echo "Option [${option_0}] ${selected_config}"
}


function opt_1control () {
    if [ -z "${option_1}" ]; then
        echo ""
        echo "Select a control category:"
        echo "    [0] Install"
        echo "    [1] Manage"
        read -p "# " option_1
    fi

    # Install selected
    if [[ ${option_1} = '0' ]] ; then
        opt_1control_0install
    # Manage selected
    elif [[ ${option_1} = '1' ]] ; then
        opt_1control_1manage
    fi
}

function opt_1control_0install() {
    echo "Option [0]; Install selected."
    echo ""
    echo "Installing ${selected_config}..."
    python3 install_config.py $selected_config
}
function opt_1control_1manage() {
    echo "Option [1]; Manage selected."

    # Select what to do with configuration
    if [ -z "${option_1_1}" ]; then
        echo ""
        echo "Select a control category:"
        echo "    [0] TMuLe"
        echo "    [1] Git"
        read -p "# " option_1_1
    fi

    # TMuLe Control selected
    if [[ ${option_1_1} = '0' ]] ; then
        opt_1control_1manage_0tmule
    # Git Control selected
    elif [[ ${option_1_1} = '1' ]] ; then
        opt_1control_1manage_1git
    fi

}

function opt_1control_1manage_0tmule() {
    echo "Option [0]; TMuLe Control selected."

    # Select tmule file to use
    if [ -z "${option_1_1_0}" ]; then
        echo ""
        source ./ffr.sh
        ws=$(get_ws $selected_config)
        tmules=$(get_tmules ${ws})

        echo "Select a tmule file."
        i=1
        for tmule_file in $tmules
        do
            echo [$i] $(echo ${tmule_file} | sed "s|${ws}||g")
            i=$(($i+1))
        done
        read -p "# " option_1_1_0
    fi
    export selected_tmule=$(echo $tmules | cut -d ' ' -f $option_1_1_0)
    export tmule_session=$(cat $selected_tmule | grep "session: " | sed "s|session:\ ||g")
    export short_tmule=$(echo ${selected_tmule} | sed "s|$ws||g")
    echo "Option [${option_1_1_0}]: $short_tmule"

    # Select action to take with file
    opt_1control_1manage_0tmule_0action
}


function opt_1control_1manage_0tmule_0action() {

    if [ -z "${option_1_1_0_0}" ]; then
        echo ""
        echo "Select a TMuLe process"
        echo "    [0] Launch"
        echo "    [1] Stop"
        echo "    [2] Terminate"
        read -p "# " option_1_1_0_0
    fi

    # Identify Farm TMuLe
    export FFR_FARM_SHARE=$WS_DIR/shared_ws/install/ffr_farm/share/ffr_farm
    export farmTm=$FFR_FARM_SHARE/tmule/farm_example.tmule.yaml

    # Identify Field TMuLe
    export FFR_FIELD_SHARE=$WS_DIR/shared_ws/install/ffr_field/share/ffr_field
    export fieldTm=$FFR_FIELD_SHARE/tmule/field_example.tmule.yaml

    # Define TMuLe launch functions
    function rename () { tmux rename-session -t field_1_example $1 ; }
    function set_source () {
        echo 'source $WS_DIR/$1/install/setup.bash' > ~/.field_source ;
    }
    function farm () { set_source farm_ws ; tmule -c $farmTm $1 ; }
    function field () { set_source $1_ws ; tmule -c $fieldTm $2 ; rename $1 ; }


    # Git Control selected
    if [[ ${option_1_1_0_0} = '0' ]] ; then
        echo "Option [0]; TMuLe Launch selected."
        echo "tmule -c $selected_tmule launch"
        echo "tmux rename-session -t $tmule_session $1"

    elif [[ ${option_1_1_0_0} = '1' ]] ; then
        echo "Option [1]; TMuLe Launch selected."
        echo "tmux rename-session -t $tmule_session $1"
        echo "tmule -c $selected_tmule stop"

    elif [[ ${option_1_1_0_0} = '2' ]] ; then
        echo "Option [2]; TMuLe Terminate selected."
        echo "tmux rename-session -t $1 $tmule_session"
        echo "tmule -c $selected_tmule terminate"
    fi
}



function opt_1control_1manage_1git() {
    echo "Option [1]; Git Control selected."

    if [ -z "${option_1_1_1}" ]; then
        echo ""
        echo "Select a git process"
        echo "    [0] Status"
        echo "    [1] Pull"
        echo "    [2] Checkout"
        read -p "# " option_1_1_1
    fi

    # Git Control selected
    if [[ ${option_1_1_1} = '0' ]] ; then
        echo "Option [0]; Git Status selected."
        python3 check_git_status.py $selected_config

    elif [[ ${option_1_1_1} = '1' ]] ; then
        echo "Option [1]; Git Pull selected."

    elif [[ ${option_1_1_1} = '2' ]] ; then
        echo "Option [2]; Git Checkout selected."
    fi
}
