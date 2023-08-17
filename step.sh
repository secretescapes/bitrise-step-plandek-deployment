#!/bin/bash

red=$'\e[31m'
green=$'\e[32m'
reset=$'\e[0m'

echo "${GIT_CLONE_COMMIT_HASH}"
echo "${client_key}"
echo "${pipeline}"
echo "${build}"
echo "${commits}"

body='{
  {
  "client_key": "'${client_key}'",
  "pipeline": "'${pipeline}'",
  "build": "'${build}'",
  "calculate_commits_in_build": false,
  "commits": "'${commits}'",
'

if [ "$BITRISE_BUILD_STATUS" == "0" ]; 
then
  body+='    "status": "success"'
else
  body+='    "status": "failure"'
fi

body+='
}'

echo "${body}"

res="$(curl -X POST -H 'Content-Type: application/json' -H 'Authorization: Bearer "{api_token}"' --data-raw "${body}" https://pipelines.plandek.com/deployments/v1/deployment)"

echo "${res}"

if [[ $res == *"detail"* ]]; then
  error="$(echo $res | jq '.title .detail' | tr -d '"')"
  echo $'\t'"${red}❗️ Failed $error ${reset}"
else
  status="$(echo $res | jq '.status' | tr -d '"')"
  echo "Status = " $status
fi

# {
#     "detail": "Unknown build 3435 for client secret-escapes and pipeline app-android",
#     "status": 400,
#     "title": "Bad Request",
#     "type": "about:blank"
# }

# {
#     "detail": "Invalid credentials",
#     "status": 401,
#     "title": "Unauthorized",
#     "type": "about:blank"
# }

# {
#     "deployment": {
#         "branch_name": "release/5.4.5",
#         "build": "3435",
#         "calculate_commits_in_build": false,
#         "client_key": "secret-escapes",
#         "commenced_at": null,
#         "commits": [
#             "asdf"
#         ],
#         "context": null,
#         "deployed_at": "2023-08-07T10:13:12+00:00",
#         "pipeline": "app-android",
#         "status": "success"
#     },
#     "status": "OK"
# }
