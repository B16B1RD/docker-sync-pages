# docker-sync-pages
WIP

## Build
```
docker build -t asakaguchi/sync-pages .
```

## Usage
```
docker run -d -p 80 -e GITHUB_REPOSITORY=<repository> -e GITHUB_BRANCH=<branch> -e GITHUB_PUBLISHDIR=<dir> -e GITHUB_USERNAME=<username> -e GITHUB_ACCESS_TOKEN=<access token> -e GITHUB_SECRET_TOKEN=<secret> asakaguchi/sync-pages
```

## Environment Variables
- GITHUB_REPOSITORY: repository (https only)
- GITHUB_BRANCH: branch
- GITHUB_PUBLISHDIR: web page directory
- GITHUB_USERNAME: username for GitHub
- GITHUB_ACCESS_TOKEN: psersonal access token
- GITHUB_SECRET_TOKEN: webhook's secret
