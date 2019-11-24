#!/bin/bash

STACK_TO_UPDATE=${1:-Ec2}

# Activate using utility shell
source ~/.Shells_for_aws/util_shell.sh

# Default profile executing aws cli
VALUE_TO_FIND="DEFAULT_PROFILE"
get_value_from_config $VALUE_TO_FIND
DEFAULT_PROFILE=$ret_value

# get the path of template
VALUE_TO_FIND="PATH_OF_STACK"
get_value_from_config $VALUE_TO_FIND
PATH_OF_STACK=$ret_value

DATE=`date +"%m-%d-%H-%M"`

CSNAME="$STACK_TO_UPDATE-`date +"%m-%d-%H-%M"`-$DEFAULT_PROFILE"

# TODO: get a template diff
NEW_FILE=$PATH_OF_STACK$STACK_TO_UPDATE.yaml
aws cloudformation --profile $DEFAULT_PROFILE get-template --template-stage Original --stack-name $STACK_TO_UPDATE

# echo $NEW_FILE

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


# aws cloudformation create-change-set \
#                     --stack-name $STACK_TO_UPDATE \
#                     --change-set-name $CSNAME \
#                     --template-file $PATH_OF_STACK$STACK_TO_UPDATE.yaml
