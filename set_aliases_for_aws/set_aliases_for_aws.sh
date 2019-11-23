#!/bin/bash

# Usage
#  Add source ./<path of aliase.sh> to your ~/.bashrc

MFA_ON=true


# Activate using utility shell
REFERENCED_FILE=auto_mfa_for_aws_cli/mfa.sh
if [ -f "$REFERENCED_FILE" ]; then
    cp $REFERENCED_FILE ~/auto_mfa_for_aws_cli/mfa.sh
else
    cd ..
    cp $REFERENCED_FILE ~/auto_mfa_for_aws_cli/mfa.sh
fi

if [ $MFA_ON = true ]; then 
    alias mfa="source ~/auto_mfa_for_aws_cli/mfa.sh $1 $2"
fi