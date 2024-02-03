#!/usr/bin/env bash

# constant
glibc_prefix=/opt/patch-vscode-1-86-for-old-linux

# check
if [ $(id -u) != "0" ] ;then
    echo 'Error: must use root exec the script'
    echo "Usage: sudo $0 <username>"
    exit 1
fi

if [ -z $1 ] ;then
    echo 'Error: miss param <username>'
    echo "Usage: sudo $0 <username>"
    exit 1
fi

home_dir=$(su $1 sh -c 'echo $HOME')

if [ -z $home_dir ] ;then
    echo "Error: username $1 not exist"
    echo "Usage: sudo $0 <username>"
    exit 1
fi

# download tools
if test -d $glibc_prefix ;then
    echo "patched tools has installed, skip it."
else
    mkdir -p $glibc_prefix
    wget -O patch-vscode-1-86-for-old-linux.tar.gz https://github.com/rectcircle/patch-vscode-1-86-for-old-linux/releases/download/v0.0.1/patch-vscode-1-86-for-old-linux.tar.gz
    tar -zxvf patch-vscode-1-86-for-old-linux.tar.gz -C $glibc_prefix
    rm -rf patch-vscode-1-86-for-old-linux.tar.gz
fi

# do patch
vscode_node_paths=$(ls $home_dir/.vscode-server/bin/*/node)

if [ -z $vscode_node_paths ] ;then
    echo "Warning: vscdoe-server node not found on $home_dir/.vscode-server/bin/*/node, please first connect to the username ($1) of machine once"
    exit 0
fi

for node_path in "${vscode_node_paths[@]}"
do
    p=$(dirname $node_path)
    check_path=$p/bin/helpers/check-requirements.sh
    echo "=== check $node_path ==="
    $node_path -v
    if [ $? -ne 0 ] ;then
        echo "=== backup $node_path to node.bak ==="
        cp -rf $node_path $node_path.bak
        echo "=== backup $check_path to check-requirements.sh.bak ==="
        cp -rf $check_path $check_path.bak
        echo "=== will patch $node_path ==="
        $glibc_prefix/bin/patchelf --set-interpreter $glibc_prefix/lib/ld-linux-x86-64.so.2 $node_path
        echo "=== will clear $check_path ==="
        echo '#!/usr/bin/env sh' > $check_path
        echo 'exit 0' >> $check_path
    else
        echo 'the node is good, no need patch it'
    fi
done
