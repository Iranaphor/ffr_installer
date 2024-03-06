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
    if [ -n "$3" ]; then export option_1=$2; else export option_1=''; fi
    if [ -n "$4" ]; then export option_1_0=$3; else export option_1_0=''; fi
    if [ -n "$4" ]; then export option_1_1=$3; else export option_1_1=''; fi
    if [ -n "$4" ]; then export option_1_1_0=$4; else export option_1_1_0=''; fi
    if [ -n "$4" ]; then export option_1_1_1=$4; else export option_1_1_1=''; fi

    clear

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
    echo "Option [${option_1}] ${selected_config}"
}


function opt_1control () {
    if [ -z "${option_1}" ]; then
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
    echo -e "\n"
    echo "Installing ${selected_config}..."
    python3 install_config.py $selected_config
}
function opt_1control_1manage() {
    echo "Option [1]; Manage selected."

    # Select what to do with configuration
    if [ -z "${option_1_1}" ]; then
        echo -e "\n"
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
}

function opt_1control_1manage_1git() {
    echo "Option [1]; Git Control selected."

    if [ -z "${option_1_1_1}" ]; then
    echo -e "\n\n"
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


# config
# - get config
# install
# - 
# - manage
#
#
#
#
#
#
