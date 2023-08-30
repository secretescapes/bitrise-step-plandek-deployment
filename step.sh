#!/bin/bash
# fail if any commands fails
set -e

# debug log
if [ "$debug" == "true" ];
then
  set -x
  curl_options="-v"
fi

red=$'\e[31m'
green=$'\e[32m'
reset=$'\e[0m'

body='{
  "client_key": "'${client_key}'",
  "pipeline": "'${pipeline}'",
  "build": "'${build}'",
'

if [ -n "$branch_name" ];
then
  body+='  "branch_name": "'${branch_name}'",
'
fi

if [ "$calculate_commits_in_build" == "true" ];
then
  body+='  "calculate_commits_in_build": true,
'
else
  body+='  "calculate_commits_in_build": false,
'
fi

if [ -n "$commits" ];
then
  body+='  "commits": "'${commits}'",
'
fi

if [ -n "$commenced_at" ];
then
  body+='  "commenced_at": "'${commenced_at}'",
'
fi

if [ -n "$context" ];
then
  body+='  "context": "'${context}'",
'
fi

if [ -n "$deployed_at" ];
then
  body+='  "deployed_at": "'${deployed_at}'",
'
fi

if [ "$status" == "automatic" ];
then
  if [ "$BITRISE_BUILD_STATUS" == "0" ];
  then
    body+='  "status": "success"
  '
  else
    body+='  "status": "failure"
  '
  fi
else
  body+='  "status": "'${status}'"
'
fi

body+='}'

if [ "$dry_run" == "true" ];
then
  echo "Dry run - request body: "
  echo "${body}"
  echo

  # validating the body JSON
  echo "${body}" | jq

  exit
fi

res=$(curl -H 'Content-Type: application/json' -H "Authorization: Bearer ${api_token}" --data-raw "${body}" ${curl_options} https://pipelines.plandek.com/deployments/v1/deployment)

if [[ $res == *"detail"* ]]; then

  echo "Request body:"
  echo "${body}"
  echo
  echo "Response:"
  echo "${res}"

  error="$(echo $res | jq '.detail' | tr -d '"')"
  echo $'\t'"${red}❗️ Failed $error ${reset}"
  exit 1
else
  status="$(echo $res | jq '.status' | tr -d '"')"
  echo "Status = " $status
fi
