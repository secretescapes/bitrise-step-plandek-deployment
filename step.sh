#!/bin/bash

red=$'\e[31m'
green=$'\e[32m'
reset=$'\e[0m'

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


res="$(curl -X POST -H 'Content-Type: application/json' -H 'Authorization: Bearer "{api_token}"' --data-raw "${body}" https://pipelines.plandek.com/deployments/v1/deployment)"

if [[ $res == *"errorMessages"* ]]; then
  error="$(echo $res | jq '.errors .name' | tr -d '"')"
  echo $'\t'"${red}❗️ Failed $error ${reset}"
else
  name="$(echo $res | jq '.name' | tr -d '"')"
  id="$(echo $res | jq '.id' | tr -d '"')"
  description="$(echo $res | jq '.description' | tr -d '"')"
  projectId="$(echo $res | jq '.projectId' | tr -d '"')"
  project="$(echo $res | jq '.project' | tr -d '"')"
  self="$(echo $res | jq '.self' | tr -d '"')"
  echo $'\t'"${green}✅ Success!${reset}"
  echo "Id = " $id
  echo "Name = " $name
  echo "Description = " $description
  echo "Project ID = " $projectId
  echo "Project = " $project
  echo "API = " $self

  JIRA_VERSION_URL="https://${jira_domain}/projects/${project_prefix}/versions/${id}"
  echo "JIRA VERSION = " $JIRA_VERSION_URL
fi

envman add --key JIRA_VERSION_URL --value "${JIRA_VERSION_URL}"

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
#             "c2d755df237e05756482a83b819044e1db61dfe4"
#         ],
#         "context": null,
#         "deployed_at": "2023-08-07T10:13:12+00:00",
#         "pipeline": "app-android",
#         "status": "success"
#     },
#     "status": "OK"
# }
