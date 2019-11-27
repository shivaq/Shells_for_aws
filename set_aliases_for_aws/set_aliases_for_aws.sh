#!/bin/bash

# Usage
#  Add source ./<path of aliase.sh> to your ~/.bashrc

MFA_ON=true

setToken() {
    ENV_FILE=~/.Shells_for_aws/export_env_vir_skdjflsdjflseiworueiruowieuruwo
    touch $ENV_FILE
    ~/.Shells_for_aws/auto_mfa_for_aws_cli/mfa.sh $1 $2
    # you can't set environment variables in mfa.sh. So do that here.
    source $ENV_FILE
    echo "Your credentials have been set in your env."
    rm -f $ENV_FILE
}
alias mfa=setToken

if [ $MFA_ON = true ]; then 
    alias mfa=setToken
fi
