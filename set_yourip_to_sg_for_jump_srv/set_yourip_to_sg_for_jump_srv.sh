#!/bin/bash

# Get my own IP address
MY_IP_ADDRESS=$(curl http://checkip.amazonaws.com/)

# Activate using utility shell
source ~/.Shells_for_aws/util_shell.sh

# Default profile executing aws cli
VALUE_TO_FIND="DEFAULT_PROFILE"
get_value_from_config $VALUE_TO_FIND
DEFAULT_PROFILE=$ret_value


STACK_TO_UPDATE=${1:-Sg}
PARAM_KEY_TO_UPDATE="MyIpAddress"
echo "My IP address is $MY_IP_ADDRESS"

# Parameter list to update
LIST_OF_PARAMS="ParameterKey=$PARAM_KEY_TO_UPDATE,ParameterValue=$MY_IP_ADDRESS/32"
# LIST_OF_PARAMS="ParameterKey=$PARAM_KEY_TO_UPDATE,ParameterValue=８/32"
# LIST_OF_PARAMS="ParameterKey=$PARAM_KEY_TO_UPDATE,ParameterValue=8.8.8.8/32"


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
