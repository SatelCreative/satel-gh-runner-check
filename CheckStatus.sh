#!/bin/bash
STATUSES=()
ERRORS=()

function check_status() {
    RUNNER_NAME=$1
    RESPONSE=$(curl -L \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${GITHUB_ADMIN_TOKEN}" \
        -H "X-GitHub-Api-Version: ${GITHUB_API_VERSION}" \
        "https://api.github.com/orgs/${ORG_NAME}/actions/runners")
        
    echo "RESPONSE=${RESPONSE}"
    STATUS=$(echo "${RESPONSE}" | jq -r --arg runnerName "${RUNNER_NAME}" \
    '.runners | map(select(.name == $runnerName)) | .[0].status || "UNKNOWN"' 2>&1)
    # STATUS=$(echo "${RESPONSE}" | jq ".runners[] | select(.name == \"${RUNNER_NAME}\") | .status" 2>&1)
    echo "STATUS=${STATUS}"
    if [ $? -ne 0 ]; then
        ERRORS+=("${STATUS}")
    else
        STATUSES+=("${STATUS}")
    fi
}

runners=(${RUNNER_NAMES})
for runner in "${runners[@]}"; do
    check_status "${runner}"
done

# These outputs are used in other steps/jobs via action.yml
echo "::set-output name=status::${STATUSES[@]}"
echo "::set-output name=errors::${ERRORS[@]}"
