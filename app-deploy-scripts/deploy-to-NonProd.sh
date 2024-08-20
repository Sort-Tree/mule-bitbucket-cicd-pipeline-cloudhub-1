#!/bin/bash

# Args:
# 1. deployment.envName : either 'DEV','QA','UAT','PreProd','HotFix'
# 2. deployment.major.version
# 3. deployment.access : either 'x' for apps exposed via external DLB, or blank otherwise

if [ -z "$1" ]
then
	echo -n "Environment name is missing. Cannot continue."
fi

if [ -z "$2" ]
then
	echo -n "Deployment major version is missing. Cannot continue."
fi

case $1 in 

  'DEV')
    ENV_SHORT='dv-'
    ENV_MULE='dev'
    CA_CLIENT_ID=$CONNECTED_APP_DEV_CLIENT_ID
    CA_CLIENT_SECRET=$CONNECTED_APP_DEV_CLIENT_SECRET
    AP_CLIENT_ID=$AP_CLIENT_ID_DEV
    AP_CLIENT_SECRET=$AP_CLIENT_SECRET_DEV
    MULE_ENCRYPT_KEY=$MULE_ENCRYPT_KEY_DEV
    ;;

  'QA')
    ENV_SHORT='qa-'
    ENV_MULE='qa'
    CA_CLIENT_ID=$CONNECTED_APP_QA_CLIENT_ID
    CA_CLIENT_SECRET=$CONNECTED_APP_QA_CLIENT_SECRET
    AP_CLIENT_ID=$AP_CLIENT_ID_QA
    AP_CLIENT_SECRET=$AP_CLIENT_SECRET_QA
    MULE_ENCRYPT_KEY=$MULE_ENCRYPT_KEY_QA
    ;;

  'UAT')
    ENV_SHORT='ua-'
    ENV_MULE='uat'
    CA_CLIENT_ID=$CONNECTED_APP_UAT_CLIENT_ID
    CA_CLIENT_SECRET=$CONNECTED_APP_UAT_CLIENT_SECRET
    AP_CLIENT_ID=$AP_CLIENT_ID_UAT
    AP_CLIENT_SECRET=$AP_CLIENT_SECRET_UAT
    MULE_ENCRYPT_KEY=$MULE_ENCRYPT_KEY_UAT
    ;;

  'PrePROD')
    ENV_SHORT='pp-'
    ENV_MULE='preprod'
    CA_CLIENT_ID=$CONNECTED_APP_PREPROD_CLIENT_ID
    CA_CLIENT_SECRET=$CONNECTED_APP_PREPROD_CLIENT_SECRET
    AP_CLIENT_ID=$AP_CLIENT_ID_PREPROD
    AP_CLIENT_SECRET=$AP_CLIENT_SECRET_PREPROD
    MULE_ENCRYPT_KEY=$MULE_ENCRYPT_KEY_PREPROD
    SKIP_MUNITS='-DskipMunitTests'
    ;;

  'HotFix')
    ENV_SHORT='hf-'
    ENV_MULE='hotfix'
    CA_CLIENT_ID=$CONNECTED_APP_HOTFIX_CLIENT_ID
    CA_CLIENT_SECRET=$CONNECTED_APP_HOTFIX_CLIENT_SECRET
    AP_CLIENT_ID=$AP_CLIENT_ID_HOTFIX
    AP_CLIENT_SECRET=$AP_CLIENT_SECRET_HOTFIX
    MULE_ENCRYPT_KEY=$MULE_ENCRYPT_KEY_HOTFIX
    ;;

  *)
    echo -n 'Unknown Non-Prod environment: '+$1+' - Please check pipeline configuration.'
    ;;
esac

echo -n 'Deploying to '+$1
echo -n ''

mvn deploy -DmuleDeploy \
-Ddeployment.access=$3 \
-DconnectedApp.clientId=$CA_CLIENT_ID \
-DconnectedApp.clientSecret=$CA_CLIENT_SECRET \
-Ddeployment.major.version=$2 \
-Ddeployment.buId=$AP_BUS_GROUP_ID \
-Ddeployment.workers=$NUM_OF_WORKERS \
-Ddeployment.workerType=$WORKER_TYPE \
-Dap.client_id=$AP_CLIENT_ID \
-Dap.client_secret=$AP_CLIENT_SECRET \
-Dencrypt.key=$MULE_ENCRYPT_KEY \
-Ddeployment.regionShort=euw2 \
-Ddeployment.region=eu-west-2 \
-Ddeployment.envShort=$ENV_SHORT \
-Ddeployment.envName=$1 \
-Dapi.env=$ENV_MULE \
-Dmule.env=$ENV_MULE $SKIP_MUNITS