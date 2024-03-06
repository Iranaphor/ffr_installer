function get_git_status() {
    for output in $(find $1 -name .git)
    do
        cd $(dirname $output)
        echo $(dirname $output)
        git status | grep "On\|Your"
        git status -s
        cd - > /dev/null
        echo " "
    done
}
#function get_status_fields() { get_git_status ~/ros2_riseholme_park_fields ; }
function get_status_here() { get_git_status . ; }




function pull_git_here() {
    for output in $(find ~/ros2_riseholme_park_fields -name .git)
    do
        if [[ "$output" == *"environment_common"* ]] ||
           [[ "$output" == *"environment_template"* ]] ||
           [[ "$output" == *"topological_navigation"* ]]
            then
            cd $(dirname $output)
            echo $(dirname $output)
            git pull
            cd - > /dev/null
            echo " "
        fi
    done
    for output in $(find ~/ros2_riseholme_park_fields -name .git)
    do
        if [[ "$output" == *"farm_coordination_systems"* ]]
            then
            cd $(dirname $output)
            echo $(dirname $output)
            git pull
            cd - > /dev/null
            echo " "
        fi
    done
}
