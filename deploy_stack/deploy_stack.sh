#!/bin/bash

# Activate using utility shell
source ~/.Shells_for_aws/util_shell.sh

# Get default region
VALUE_TO_FIND="PATH_OF_STACK"
get_value_from_config $VALUE_TO_FIND

# Set a path to your template files
PATH_OF_STACK=$ret_value

STACK_TO_UPDATE=${1:-Ec2}

# Default profile executing aws cli
VALUE_TO_FIND="DEFAULT_PROFILE"
get_value_from_config $VALUE_TO_FIND
DEFAULT_PROFILE=$ret_value

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