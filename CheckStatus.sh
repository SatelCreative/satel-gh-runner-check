#!/bin/bash
STATUSES=()
RUNNER_STATUS=()

function check_status(){
    RUNNER_NAME=$1
    RESPONSE=$(curl -L \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${GITHUB_RUNNER_TOKEN}" \
        -H "X-GitHub-Api-Version: ${GITHUB_API_VERSION}" \
        https://api.github.com/orgs/${ORG_NAME}/actions/runners)
 
    RUNNERS=$(echo "${RESPONSE}" | jq -r '.runners')
    if [ "${RUNNERS}" = "null" ]; then
        echo "Problem with the token"
        exit 1
        return
    fi

    STATUS=$(echo "${RESPONSE}" | jq -r ".runners[] | select(.name == \"${RUNNER_NAME}\") | .status")
    RUNNER_STATUS+=("$(echo "${RUNNER_NAME^^} IS ${STATUS^^}, ")")
    STATUSES+=("${STATUS^^}")
}

runners=( ${RUNNER_NAMES} )
for runner in "${runners[@]}"
do
    check_status "${runner}"
done 

# These outputs are used in other steps/jobs via action.yml
echo "status=${STATUSES[@]}" >> $GITHUB_OUTPUT
echo "each_runner_status=${RUNNER_STATUS[@]}" >> $GITHUB_OUTPUT
