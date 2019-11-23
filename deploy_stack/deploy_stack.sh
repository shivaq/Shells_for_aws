#!/bin/bash

# Set a path to your template files
PATH_OF_STACK="/Users/yasuakishibata/Dropbox/01.study/00.Git/01.CloudFormation/ActualEnv/"

# Default profile executing aws cli
DEFAULT_PROFILE=${1:-sls_admin_role}

STACK_TO_UPDATE=${2:-Sg}

# deploy your stacks
aws cloudformation deploy --profile $DEFAULT_PROFILE --template-file $PATH_OF_STACK$STACK_TO_UPDATE.yaml --stack-name $STACK_TO_UPDATE

# Check No updates are to be performed.
ret_val=$?
if [ $ret_val -eq 255 ];then
    echo "There is nothing to be updated."
    exit
fi

while true
do

    # Get stack status
    test=$(aws cloudformation describe-stack-events \
        --profile $DEFAULT_PROFILE \
        --stack-name $STACK_TO_UPDATE \
        --max-items 1)
    stack_event="$(echo $test | jq '."StackEvents"[0]."ResourceStatus"'| tr -d '""')"
    event_reason="$(echo $test | jq '."StackEvents"[0]."ResourceStatusReason"'| tr -d '""')"
    logical_id="$(echo $test | jq '."StackEvents"[0]."LogicalResourceId"'| tr -d '""')"

    echo "$logical_id is $stack_event because $event_reason"

    # Check stack status
    if [ $stack_event = "UPDATE_ROLLBACK_COMPLETE" ] || [ $stack_event = "UPDATE_COMPLETE" ];then
        echo "Yes $stack_event"
        if [ $logical_id = $STACK_TO_UPDATE ];then
            echo "Stack change is finished"
            exit
        fi
    fi
    sleep 10s

done
