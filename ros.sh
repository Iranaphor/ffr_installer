function set_new_domain_id () {
    export ROS_DOMAIN_ID=1
    for i in {1..255}
    do
        #echo "Testing ROS_DOMAIN_ID=$i"
        export ROS_DOMAIN_ID=$i
        t=$(ros2 topic list | grep -v "/rosout\|/parameter_events" | wc -l)

        if [ $t -lt 1 ]
        then
            echo "Found an empty ROS_DOMAIN_ID, $i"
            break
        else
            echo "ROS_DOMAIN_ID==$i is in use"
        fi
    done
    echo "export ROS_DOMAIN_ID=$ROS_DOMAIN_ID" > $HOME/.ffrrc
}
