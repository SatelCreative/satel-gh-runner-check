# GitHub self-hosted runner status check 
This centralized GitHub action checks status (online, offline) of a self hosted runnner 

## Usage 
```yml
name: Runner status check
on:
  ... 

jobs:
  self-hosted-status:
    runs-on: ubuntu-latest
    outputs:
      runner-status: ${{ steps.runnerstatus.outputs.status }}
    steps:
      - name: Check runner status
        id: runnerstatus
        uses: SatelCreative/satel-gh-runner-check@1.0.0
        with: 
          runner-names: <names-of-runners>  # "runner1 runner2"       
          github-admin-token: ${{ secrets.ADMIN_TOKEN }} # Should have access to manage runner
          github-api-version: "2022-11-28"
          org-name": <organization-name>
```
        
And it can be used for other jobs as follows
```yml
 # if self-hosted is offline, runs the job on a GitHub hosted runner
 runs-on: "${{ needs.self-hosted-status.outputs.runner-status != 'offline' && 'self-hosted' || 'ubuntu-latest' }}" 
```
