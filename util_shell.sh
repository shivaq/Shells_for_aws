#!/bin/bash

function get_stack_status {


DEFAULT_PROFILE=$1
STACK_TO_UPDATE=$2

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
        if [ $logical_id = $STACK_TO_UPDATE ];then
            echo "Stack change is finished"
            return 0
        fi
    fi
    sleep 10s

done
}

function update_stack_parameter {

    DEFAULT_PROFILE=$1
    STACK_TO_UPDATE=$2
    LIST_OF_PARAMS=$3

    # Execute updating stack
    aws cloudformation update-stack --profile $DEFAULT_PROFILE \
                                    --use-previous-template \
                                    --stack-name $STACK_TO_UPDATE \
                                    --parameters $LIST_OF_PARAMS

}

function get_value_from_config {

    CFG_FILE=shell_for_aws.cfg
    VALUE_TO_SEARCH=$1

    if [ -f "$CFG_FILE" ]; then
    VALUE=$(grep "^$VALUE_TO_SEARCH" $CFG_FILE | cut -d '=' -f 2- | tr -d '""')
    KEY=$(grep "^$VALUE_TO_SEARCH" $CFG_FILE | cut -d '=' -f -1 | tr -d '""')
    else
        cd ..
        pwd
        VALUE=$(grep "^$VALUE_TO_SEARCH" $CFG_FILE | cut -d '=' -f 2- | tr -d '""')
        KEY=$(grep "^$VALUE_TO_SEARCH" $CFG_FILE | cut -d '=' -f -1 | tr -d '""')
        cd -
        pwd
    fi

    ret_value=$VALUE
    ret_key=$KEY
}
