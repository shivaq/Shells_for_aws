#!/bin/bash

# Set a path to your template files
PATH_OF_STACK="/Users/yasuakishibata/Dropbox/01.study/00.Git/01.CloudFormation/ActualEnv/"

STACK_TO_UPDATE=${1:-Ec2}

# Default profile executing aws cli
DEFAULT_PROFILE=${2:-sls_admin_role}

# Activate using utility shell
UTIL_FILE=util_shell.sh
if [ -f "$UTIL_FILE" ]; then
    echo "$UTIL_FILE is here"
    . util_shell.sh
else
    echo "$UTIL_FILE is not here"
    cd ..
    . util_shell.sh
fi

# deploy your stacks
aws cloudformation deploy --profile $DEFAULT_PROFILE --template-file $PATH_OF_STACK$STACK_TO_UPDATE.yaml --stack-name $STACK_TO_UPDATE

# Check No updates are to be performed.
ret_val=$?
if [ $ret_val -eq 255 ];then
    echo "There is nothing to be updated."
    exit
else
    get_stack_status $DEFAULT_PROFILE $STACK_TO_UPDATE
fi