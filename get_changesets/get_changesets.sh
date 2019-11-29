#!/bin/bash

# Activate using utility shell
source ~/.Shells_for_aws/util_shell.sh

logit "###########################"
logit "# Start get_changesets.sh"
logit "###########################"
STACK_TO_UPDATE=${1:-Ec2}

logit "Stack to update is $STACK_TO_UPDATE"


# Get the default profile executing aws cli
get_value_from_config "DEFAULT_PROFILE"
DEFAULT_PROFILE=$ret_value

logit "DEFAULT_PROFILE is $DEFAULT_PROFILE"

# Get the path of template
VALUE_TO_FIND="PATH_OF_STACK"
get_value_from_config "PATH_OF_STACK"
PATH_OF_STACK=$ret_value

logit "PATH_OF_STACK is $PATH_OF_STACK"

# Make the path of local cfn template
NEW_FILE=$PATH_OF_STACK$STACK_TO_UPDATE.yaml

# Validate template.
validate_template $DEFAULT_PROFILE $NEW_FILE

ret_val=$?
if [ $ret_val -eq 255 ];then
    echo "Validation error."
    exit
else
    echo "Yes!Yes!Ok!OK Validation is OK!!!"
fi

# Get a template diff
logit "Do diff!"
get_a_template_diff $DEFAULT_PROFILE $STACK_TO_UPDATE $NEW_FILE

echo "\nこの変更で、変更セットを作成しますか？"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo "変更セット作成をすすめます"; break;;
        No ) echo "変更セット作成を中止します"; exit;;
    esac
done

# Get the path of template in S3
get_value_from_config "CFN_BUCKET"
CFN_BUCKET=$ret_value

# Assemble target s3 path for aws s3 command
get_value_from_config "CFN_TEMPLATE_PATH"
CFN_TEMPLATE_PATH=$ret_value
CFN_STORE=s3://$CFN_BUCKET/$CFN_TEMPLATE_PATH/

# Assemble template url
get_value_from_config "DEFAULT_REGION"
DEFAULT_REGION=$ret_value
TEMPLATE_URL=https://$CFN_BUCKET.s3-$DEFAULT_REGION.amazonaws.com/$CFN_TEMPLATE_PATH/$STACK_TO_UPDATE.yaml

echo "Put template to $CFN_STORE"
aws s3 cp --profile $DEFAULT_PROFILE $NEW_FILE $CFN_STORE

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


aws cloudformation create-change-set \
                    --profile $DEFAULT_PROFILE \
                    --stack-name $STACK_TO_UPDATE \
                    --change-set-name $CSNAME \
                    --template-url $TEMPLATE_URL \
                    --capabilities CAPABILITY_IAM
