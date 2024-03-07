function get_fields () {
    find ~/$WS_DIR -name .git;
}

function get_configs () {
    find ./configs/*.conf.yaml;
}

function get_tmules () {
    find $1 -name *.tmule.yaml | grep src;
}

function get_ws () {
    cat $1 | grep "^ws_dir: '" | sed "s|ws_dir: '||g" | sed "s|'||g"
}
