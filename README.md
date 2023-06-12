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
          github-runner-token: ${{ secrets.SELF_HOSTED_RUNNER_TOKEN }} #Fine grained token with access to self hosted runners only 
          org-name": <organization-name>
```
        
And it can be used for other jobs as follows
```yml
 # if self-hosted is offline, runs the job on a GitHub hosted runner
 runs-on: "${{ needs.self-hosted-status.outputs.runner-status != 'offline' && 'self-hosted' || 'ubuntu-latest' }}" 
```
