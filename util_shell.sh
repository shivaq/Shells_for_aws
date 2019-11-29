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


# Get the template used in cfn stack
function get_a_template_diff {

    DEFAULT_PROFILE=$1
    STACK_TO_UPDATE=$2
    NEW_FILE=$3

    # strict=False let ctrl characters inside strings
    # jq is difficult to avoid ctrl character error so use python
    current_template="$(\
                aws cloudformation --profile $DEFAULT_PROFILE \
                get-template --template-stage Original --stack-name $STACK_TO_UPDATE\
                | python3 -c "import sys, json; \
                print(json.load(sys.stdin, strict=False)\
                ['TemplateBody'])"\
                )"

    echo "$current_template" > diff_file_flskdjfoeriuwoeutwo

    diff diff_file_flskdjfoeriuwoeutwo $NEW_FILE
    rm -f diff_file_flskdjfoeriuwoeutwo
}

LOG_FILE="/var/log/awsshell.log"
LOG_OUTPUT=ON

function logit {
    if [ $LOG_OUTPUT=ON ];then
    echo "[$USER `date +"%D %T"`] - ${*}" >> ${LOG_FILE}
    fi
}

function validate_template {

    DEFAULT_PROFILE=$1
    NEW_FILE=$2

    aws cloudformation --profile $DEFAULT_PROFILE validate-template \
                    --template-body file://"$NEW_FILE"
}