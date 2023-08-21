#!/bin/bash

red=$'\e[31m'
green=$'\e[32m'
reset=$'\e[0m'

body='{
  "client_key": "'${client_key}'",
  "pipeline": "'${pipeline}'",
  "build": "'${build}'",
  "commits": "'${commits}'",
'

if [ "$calculate_commits_in_build" == "true" ]; 
then
  body+='  "calculate_commits_in_build": true,
'
else
  body+='  "calculate_commits_in_build": false,
'
fi

if [ -n "$branch_name" ]; 
then
  body+='  "branch_name": "'${branch_name}'",
'
fi

if [ "$BITRISE_BUILD_STATUS" == "0" ]; 
then
  body+='  "status": "success"
'
else
  body+='  "status": "failure"
'
fi

body+='}'

echo "${body}"

res=$(curl -H 'Content-Type: application/json' -H "Authorization: Bearer ${api_token}" --data-raw "${body}" -v https://pipelines.plandek.com/deployments/v1/deployment)

echo "${res}"

if [[ $res == *"detail"* ]]; then
  error="$(echo $res | jq '.detail' | tr -d '"')"
  echo $'\t'"${red}❗️ Failed $error ${reset}"
else
  status="$(echo $res | jq '.status' | tr -d '"')"
  echo "Status = " $status
fi
