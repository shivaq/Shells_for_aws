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

DATE=`date +"%m-%d-%H-%M"`

CSNAME="$STACK_TO_UPDATE-`date +"%m-%d-%H-%M"`-$DEFAULT_PROFILE"

aws cloudformation create-change-set \
                    --stack-name $STACK_TO_UPDATE \
                    --change-set-name $CSNAME \
                    --template-file $PATH_OF_STACK$STACK_TO_UPDATE.yaml