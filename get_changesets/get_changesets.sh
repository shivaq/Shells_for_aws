#!/bin/bash

STACK_TO_UPDATE=${1:-Ec2}

# Default profile executing aws cli
DEFAULT_PROFILE=${2:-sls_admin_role}

# Activate using utility shell
UTIL_FILE=util_shell.sh
if [ -f "$UTIL_FILE" ]; then
    . util_shell.sh
else
    cd ..
    . util_shell.sh
fi

# get the path of template
VALUE_TO_FIND="PATH_OF_STACK"
get_value_from_config $VALUE_TO_FIND
PATH_OF_STACK=$ret_value

DATE=`date +"%m-%d-%H-%M"`

CSNAME="$STACK_TO_UPDATE-`date +"%m-%d-%H-%M"`-$DEFAULT_PROFILE"

echo "$PATH_OF_STACK"

aws cloudformation create-change-set \
                    --stack-name $STACK_TO_UPDATE \
                    --change-set-name $CSNAME \
                    --template-file $PATH_OF_STACK$STACK_TO_UPDATE.yaml
