#!/bin/bash

# Args:
# 1. deployment.access : either 'x' for apps exposed via external DLB, or blank otherwise

mvn deploy -DmuleDeploy \
-Ddeployment.access=$1 \
-DconnectedApp.clientId=$CONNECTED_APP_PROD_CLIENT_ID \
-DconnectedApp.clientSecret=$CONNECTED_APP_PROD_CLIENT_SECRET \
-Ddeployment.major.version=1 \
-Ddeployment.buId=$AP_BUS_GROUP_ID \
-Ddeployment.workers=$NUM_OF_WORKERS \
-Ddeployment.workerType=$WORKER_TYPE \
-Dap.client_id=$AP_CLIENT_ID_PROD \
-Dap.client_secret=$AP_CLIENT_SECRET_PROD \
-Dencrypt.key=$MULE_ENCRYPT_KEY_PROD \
-Ddeployment.regionShort=euw2 \
-Ddeployment.region=eu-west-2 \
-Ddeployment.envShort= \
-Ddeployment.envName=PROD \
-Dapi.env=prod \
-DskipMunitTests