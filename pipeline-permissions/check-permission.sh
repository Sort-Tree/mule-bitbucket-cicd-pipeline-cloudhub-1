#!/bin/bash

echo "Checking if user is permitted to trigger pipeline step..."

ENV_NAME=$(echo $BITBUCKET_DEPLOYMENT_ENVIRONMENT | sed 's/-.*//')

PERMISSIONS_FILE="${ENV_NAME^^}.txt"
echo "The UUID of the user who triggered this step is $BITBUCKET_STEP_TRIGGERER_UUID"
echo "Checking for user's UUID in $PERMISSIONS_FILE..."

grep "$BITBUCKET_STEP_TRIGGERER_UUID" $PERMISSIONS_FILE
if [ $? -eq 0 ]
then
  echo "Success: found the UUID for the user in the file"
  exit 0
else
  echo "Failure: I did not find the UUID for the user in the file" >&2
  exit 1
fi
