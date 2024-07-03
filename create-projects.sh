#!/bin/bash


rm -rf argocd-projects
helm create argocd-projects
rm -rf argocd-projects/templates/*
sed -e "s/PLACEHOLDER/argocd-projects/g" ./Chart.tmpl >  argocd-projects/Chart.yaml
cp argocd-project.tmpl argocd-projects/templates/
echo "env: dev" > argocd-projects/values.yaml
echo "syncWindowDuration: 24h" >> argocd-projects/values.yaml
environments=("dev" "qa" "perf" "uat" "prod")
for env in "${environments[@]}"; do
    echo "Processing environment: $env"
echo "env: $env" > argocd-projects/"$env"-values.yaml
echo "syncWindowDuration: 1h" >> argocd-projects/"$env"-values.yaml
done


