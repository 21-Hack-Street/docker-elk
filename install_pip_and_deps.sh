#!/bin/bash

# Test if pip is installed
pip3 --help > /dev/null 2>&1

if [ $? -gt 0 ]; then
    echo 'Installing python3-distutils'
    sudo apt install python3-distutils -y
    echo 'Curl get-pip.py'
    curl -sSL https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
    echo 'Exec get-pip.py'
    python3 /tmp/get-pip.py
    echo "Moving pip's scripts into /usr/local/bin"
    sudo mv "$HOME/.local/bin/pip" \
	    "$HOME/.local/bin/pip3" \
	    "$HOME/.local/bin/pip3.9.2" \
	    "/usr/local/bin/"
fi
echo 'install tweepy json elasticsearch package'
pip install tweepy elasticsearch 
