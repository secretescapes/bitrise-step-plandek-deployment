#!/bin/bash

red=$'\e[31m'
green=$'\e[32m'
reset=$'\e[0m'

body='{
  "client_key": "'${client_key}'",
  "pipeline": "'${pipeline}'",
  "build": "'${build}'",
  "calculate_commits_in_build": false,
  "commits": "'${commits}'",
'

if [ -n "$branch_name" ]; 
then
  body+='  "branch_name": "'${branch_name}'",
'
fi

if [ "$BITRISE_BUILD_STATUS" == "0" ]; 
then
  body+='  "status": "success"'
else
  body+='  "status": "failure"'
fi

body+='
}'

echo "${body}"

res="$(curl -X POST -H 'Content-Type: application/json' -H 'Authorization: Bearer "{api_token}"' --data-raw "${body}" https://pipelines.plandek.com/deployments/v1/deployment)"

echo "${res}"

if [[ $res == *"detail"* ]]; then
  error="$(echo $res | jq '.detail' | tr -d '"')"
  echo $'\t'"${red}❗️ Failed $error ${reset}"
else
  status="$(echo $res | jq '.status' | tr -d '"')"
  echo "Status = " $status
fi
