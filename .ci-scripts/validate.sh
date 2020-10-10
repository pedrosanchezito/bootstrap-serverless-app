#!/bin/sh

FOLDERPATH=$1
REGION=$2
BUCKET=$3
TABLE=$4

for shared in $(find $FOLDERPATH/shared/ -mindepth 1 -maxdepth 1 -type d)
do
  echo "############# VALIDATING ${shared} ..."
  terraform init -backend-config="region=$REGION" -backend-config="bucket=$BUCKET" -backend-config="dynamodb_table=$TABLE" $shared
  terraform validate $shared
  if [[ ${?} != 0 ]]
  then exit 1
  fi
done

for feature in $(find $FOLDERPATH/features/ -mindepth 1 -maxdepth 1 -type d)
do
  cd ${feature}
  echo "############# VALIDATING ${feature} ..."
  terraform init -backend-config="region=$REGION" -backend-config="bucket=$BUCKET" -backend-config="dynamodb_table=$TABLE" $feature/
  terraform validate $feature
  if [[ ${?} != 0 ]]
  then exit 1
  fi
done