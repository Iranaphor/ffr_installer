source ./git.sh
source ./ffr.sh

##########
# This script is to control the FFR workspaces.
# It has three pirimary uses; installing, updating, and running.
##########

export option1=''
export option2=''

function construct_ffr_workspaces () {

    if [ -n "$1" ]; then export option1=$1; else export option1=''; fi
    if [ -n "$2" ]; then export option2=$2; else export option2=''; fi

    clear
    if [ -z "${option1}" ]; then
        echo "Select a control category:"
        echo "    [0] Install"
        echo "    [1] Git"
        echo "    [2] TMuLe"
        read -p "# " option1
    fi

    # Instal control selected
    if [[ ${option1} = '0' ]] ; then
        opt1_install

    # TMuLe control selected
    elif [[ ${option1} = '1' ]] ; then
        opt1_git

    # Git Control selected
    elif [[ ${option1} = '2' ]] ; then
        opt1_tmule
    fi

}


function opt1_install() {
    source ./ffr.sh

    echo "Option [0]; Install selected."
    echo -e "\n\n"
    configs=$(get_configs)

    if [ -z "$option2" ]; then
        echo "Select an install configuration:"
        i=1
        for config in $configs
        do
          echo [$i] $config
          i=$(($i+1))
        done
        read -p "# " option2
    fi

    item=$(echo $configs | cut -d ' ' -f $option2)
    echo "Selected ${item}"
    python3 install_config.py $item
}

function opt1_git() {
    echo "Option [1]; Git Control selected."
    echo -e "\n\n"

    if [ -z "${option2}" ]; then
        echo "Select a git process"
        echo "    [1] Status"
        echo "    [2] Pull"
        echo "    [3] Checkout"
        read -p "# " option2
    fi

    # Git Control selected
    if [[ ${option2} = '1' ]] ; then
        echo "Option [1]; Git Status selected."

        for field in get_fields
        do
          get_git_status $field
        done

    elif [[ ${option2} = '2' ]] ; then
        echo "Option [2]; Git Pull selected."

    elif [[ ${option2} = '3' ]] ; then
        echo "Option [3]; Git Checkout selected."
    fi
}

function opt1_tmule() {
    echo "Option [1]; TMuLe Control selected."
}
