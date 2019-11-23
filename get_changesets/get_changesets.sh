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

# TODO: get a template diff

# TODO: get causes of changes
# TODO: get organized changed resources
# TODO: count the number of each change causes 

# TODO: output change set info
# TODO: get names of change sets

# TODO: list unexecuted change sets
# TODO: select a change set to be executed

# TODO: delete unexecuted change sets

# TODO: get a status of ec2 instance
# TODO: disable delete lock

# TODO: check if the resource is referenced 


aws cloudformation create-change-set \
                    --stack-name $STACK_TO_UPDATE \
                    --change-set-name $CSNAME \
                    --template-file $PATH_OF_STACK$STACK_TO_UPDATE.yaml
