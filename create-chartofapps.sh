#!/bin/bash
# Check if a folder argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <folder>"
  exit 1
fi

# Assign the first argument to a variable
folder="$1"

# Check if the provided argument is a valid directory
if [ ! -d "$folder" ]; then
  echo "Error: $folder is not a valid directory"
  exit 1
fi

helm create "$folder"-argocd-apps
rm -rf "$folder"-argocd-apps/templates/*
sed -e "s/PLACEHOLDER/${folder}/g" ./Chart.tmpl >  "$folder"-argocd-apps/Chart.yaml
echo > "$folder"-argocd-apps/values.yaml
sed -e "s/PLACEHOLDER/${folder}/g" ./argocd-app.tmpl > "$folder"-argocd-apps/templates/"$folder"-app.yaml
 repo_url=$(git config --get remote.origin.url)
echo "gitrepo: $repo_url " > "$folder"-argocd-apps/values.yaml

environments=("dev" "qa" "perf" "uat" "prod")
for env in "${environments[@]}"; do
    echo "Processing environment: $env"
echo "environment: $env" > "$folder"-argocd-apps/"$env"-values.yaml
echo "namespace: $env" >> "$folder"-argocd-apps/"$env"-values.yaml
echo "cluster: in-cluster" >> "$folder"-argocd-apps/"$env"-values.yaml
echo "path: $folder/mainchart/$env" >> "$folder"-argocd-apps/"$env"-values.yaml
done