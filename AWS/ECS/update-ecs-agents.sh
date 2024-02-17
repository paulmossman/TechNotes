#!/bin/bash

# Update all of the ECS Agents on all ECS Container Instances in all us-east-1 ECS Clusters
# in all of the specificed AWS Profiles.

if [ "$#" -ne "1" ]; then
   echo "Usage: $0 \"<space-separated list of AWS Profiles>\"">&2
   exit 2
fi

PROFILES=$1
REGION=us-east-1

for PROFILE in $PROFILES; do
   
   CLUSTERS=`aws ecs list-clusters --region ${REGION} --profile ${PROFILE} | jq -r '.clusterArns[]'`
   for CLUSTER in $CLUSTERS; do

      echo cluster - ${CLUSTER}

      CONTAINERS=`aws ecs list-container-instances --region ${REGION} --profile ${PROFILE} --cluster ${CLUSTER} | jq -r '.containerInstanceArns[]'`
      for CONTAINER in $CONTAINERS; do

         echo "  container - ${CONTAINER}"

         aws ecs update-container-agent --region ${REGION} --profile ${PROFILE} --cluster ${CLUSTER} --container-instance ${CONTAINER} | head -3

         echo ""
      done
   done
done
