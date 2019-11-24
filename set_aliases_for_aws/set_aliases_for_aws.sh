#!/bin/bash

# Usage
#  Add source ./<path of aliase.sh> to your ~/.bashrc

MFA_ON=true

if [ $MFA_ON = true ]; then 
    alias mfa="~/.Shells_for_aws/auto_mfa_for_aws_cli/mfa.sh $1 $2"
fi
