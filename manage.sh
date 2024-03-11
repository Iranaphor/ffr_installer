source ./git.sh
source ./ffr.sh

##########
# This script is to control the FFR workspaces.
# It has three pirimary uses; installing, updating, and running.
##########

export option1=''
export option2=''

function ffr_control () {

    # Manage input args
    if [ -n "$1" ]; then export option_0=$1; else export option_0=''; fi
    if [ -n "$2" ]; then export option_1=$2; else export option_1=''; fi
    if [ -n "$3" ]; then export option_1_0=$3; else export option_1_0=''; fi
    if [ -n "$3" ]; then export option_1_1=$3; else export option_1_1=''; fi
    if [ -n "$4" ]; then export option_1_1_0=$4; else export option_1_1_0=''; fi
    if [ -n "$4" ]; then export option_1_1_1=$4; else export option_1_1_1=''; fi
    if [ -n "$5" ]; then export option_1_1_0_0=$5; else export option_1_1_0_0=''; fi
    if [ -n "$6" ]; then export option_1_1_0_1=$6; else export option_1_1_0_1=''; fi
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

    # Reset ROS environment before installation
    export PYTHONPATH=
    export AMENT_PREFIX_PATH=
    export CMAKE_PREFIX_PATH=
    export COLCON_PREFIX_PATH=
    source /opt/ros/humble/setup.bash

    # Download and compile repositories from config
    python3 install_from_config.py $selected_config

    # Put configuration into ~/.bashrc
    python3 setup_runcom.py $selected_config



    ##ws=$(get_ws $selected_config)
    ##export conf=$ws/ffr_configure.sh
    ##export temp=$ws/tmule_temp.sh
    ##. bash_config.sh
    ##clear_ros $conf




    # Define location for TMuLe to access shared information on launch
    #????? echo 'source $ws/SHARE?' >> ~/.bashrc?????

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

    # Select workspace from which to run this file within
    if [ -z "${option_1_1_0_0}" ]; then
        echo ""
        source ./ffr.sh
        ws_list=$(get_ws_list ${ws})

        echo "Select a workspace to action the tmule file."
        i=1
        for ws_i in $ws_list
        do
            echo [$i] $(echo ${ws_i} | sed "s|${ws}\/||g")
            i=$(($i+1))
        done
        read -p "# " option_1_1_0_0
    fi
    export selected_ws=$(echo $ws_list | cut -d ' ' -f $option_1_1_0_0)
    export short_ws=$(echo ${selected_ws} | sed "s|$ws||g" | sed "s|^/||g")
    echo "Option [${option_1_1_0_0}]: $short_ws"

    # Select action to take with file
    opt_1control_1manage_0tmule_1action
}


function opt_1control_1manage_0tmule_1action() {

    if [ -z "${option_1_1_0_1}" ]; then
        echo ""
        echo "Select a TMuLe process"
        echo "    [0] Launch"
        echo "    [1] Stop"
        echo "    [2] Terminate"
        read -p "# " option_1_1_0_1
    fi

    # Git Control selected
    export session_name=$(echo ${short_ws} | sed "s|/|_|g")
    if [[ ${option_1_1_0_1} = '0' ]] ; then
        echo "Option [0]; TMuLe Launch selected."
        echo 'source $ws/$short_ws/install/setup.bash' > ~/.field_source
        echo ""
        cd $selected_ws
        echo ""
        tmule -c $selected_tmule launch
        echo ""
        cd $OLD_PWD
        echo ""
        tmux rename-session -t $tmule_session $session_name
        echo ""

    elif [[ ${option_1_1_0_1} = '1' ]] ; then
        echo "Option [1]; TMuLe Stop selected."
        echo ""
        tmux rename-session -t $tmule_session $session_name
        echo ""
        tmule -c $selected_tmule stop
        echo ""
        tmux rename-session -t $session_name $tmule_session
        echo ""

    elif [[ ${option_1_1_0_1} = '2' ]] ; then
        echo "Option [2]; TMuLe Terminate selected."
        echo ""
        tmux rename-session -t $session_name $tmule_session
        echo ""
        tmule -c $selected_tmule terminate
        echo ""
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
