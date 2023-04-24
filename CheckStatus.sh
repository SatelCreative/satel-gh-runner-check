#!/bin/bash

STATUS=$(curl -L \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${GITHUB_ADMIN_TOKEN}" \
        -H "X-GitHub-Api-Version: ${GITHUB_API_VERSION}" \
        https://api.github.com/orgs/SatelCreative/actions/runners | jq '.runners[] | select(.name == "${RUNNER_NAME}") | .status')

echo ${STATUS}

# These outputs are used in other steps/jobs via action.yml
echo "::set-output name=preview_link::${STATUS}" 

