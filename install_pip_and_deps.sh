#!/bin/bash

# Test if pip is installed
pip3 --help > /dev/null 2>&1

if [ $? -gt 0 ]; then
    echo 'Installing python3-distutils'
    sudo apt install python3-distutils
    echo 'Curl get-pip.py'
    curl -sSL https://bootstrap.pypa.io/get-pip.py -o /tmp/git-pip.py
    echo 'Exec get-pip.py'
    python3 /tmp/get-pip.py 2> /dev/null
    echo "Moving pip's scripts into /usr/local/bin"
    sudo mv ~/.local/bin/pip* /usr/local/bin 
fi
echo 'install tweepy json elasticsearch package'
pip3 install tweepy json elasticsearch
