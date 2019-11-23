#!/bin/bash

# Get my own IP address
MY_IP_ADDRESS=$(curl http://checkip.amazonaws.com/)

# Default profile executing aws cli
DEFAULT_PROFILE=${1:-sls_admin_role}


STACK_TO_UPDATE=${2:-Sg}
PARAM_KEY_TO_UPDATE="MyIpAddress"
echo "My IP address is $MY_IP_ADDRESS"

# Parameter list to update
LIST_OF_PARAMS="ParameterKey=$PARAM_KEY_TO_UPDATE,ParameterValue=$MY_IP_ADDRESS/32"
# LIST_OF_PARAMS="ParameterKey=$PARAM_KEY_TO_UPDATE,ParameterValue=８/32"
# LIST_OF_PARAMS="ParameterKey=$PARAM_KEY_TO_UPDATE,ParameterValue=8.8.8.8/32"

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

echo "Allow my jump server security group to access from $LIST_OF_PARAMS in SSH."

update_stack_parameter $DEFAULT_PROFILE $STACK_TO_UPDATE $LIST_OF_PARAMS

# Check No updates are to be performed.
ret_val=$?
if [ $ret_val -eq 255 ];then
    echo "There is nothing to be updated."
    exit
else
    get_stack_status $DEFAULT_PROFILE $STACK_TO_UPDATE
fi
