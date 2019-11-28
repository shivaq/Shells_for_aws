#!/bin/bash

# Activate using utility shell
source ~/.Shells_for_aws/util_shell.sh

logit "###########################"
logit "# Start get_changesets.sh"
logit "###########################"
STACK_TO_UPDATE=${1:-Ec2}

logit "Stack to update is $STACK_TO_UPDATE"


# Get the default profile executing aws cli
VALUE_TO_FIND="DEFAULT_PROFILE"
get_value_from_config $VALUE_TO_FIND
DEFAULT_PROFILE=$ret_value

logit "DEFAULT_PROFILE is $DEFAULT_PROFILE"

# Get the path of template
VALUE_TO_FIND="PATH_OF_STACK"
get_value_from_config $VALUE_TO_FIND
PATH_OF_STACK=$ret_value

logit "PATH_OF_STACK is $PATH_OF_STACK"

# Make the path of local cfn template
NEW_FILE=$PATH_OF_STACK$STACK_TO_UPDATE.yaml

aws cloudformation --profile $DEFAULT_PROFILE validate-template \
                    --template-body file://"$NEW_FILE"

logit "Do diff!"
# Get a template diff
get_a_template_diff $DEFAULT_PROFILE $STACK_TO_UPDATE $NEW_FILE

echo "\nこの変更で、変更セットを作成しますか？"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo "変更セット作成をすすめます"; break;;
        No ) echo "変更セット作成を中止します"; exit;;
    esac
done

DATE=`date +"%m-%d-%H-%M"`
CSNAME="$STACK_TO_UPDATE-`date +"%m-%d-%H-%M"`"

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
#                     --profile $DEFAULT_PROFILE \
#                     --stack-name $STACK_TO_UPDATE \
#                     --change-set-name $CSNAME \
#                     --template-body $PATH_OF_STACK$STACK_TO_UPDATE.yaml \
#                     --capabilities CAPABILITY_IAM
