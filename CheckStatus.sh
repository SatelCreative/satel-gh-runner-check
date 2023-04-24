#!/bin/bash
STATUSES=()

function check_status(){
    RUNNER_NAME=$1
    RESPONSE=$(curl -L \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${GITHUB_ADMIN_TOKEN}" \
        -H "X-GitHub-Api-Version: ${GITHUB_API_VERSION}" \
        https://api.github.com/orgs/SatelCreative/actions/runners)

    STATUS=$(echo "${RESPONSE}" | jq ".runners[] | select(.name == \"${RUNNER_NAME}\") | .status")
    STATUSES+=(${STATUS})
}

runners=( ${RUNNER_NAMES} )
for runner in "${runners[@]}"
do
check_status "${runner}"
done 

# These outputs are used in other steps/jobs via action.yml
echo "::set-output name=status::${STATUSES[@]}"
