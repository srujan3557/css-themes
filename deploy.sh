#!/usr/bin/env bash
if [ -z "$1" ] & [ -z "$2" ] & [ -z "$3" ]
then
  echo "Please pass in your namespace. For example, \"./deploy.sh <my-namespace><branchname> <pipeline-selection> <side>\""
  echo "    my-namespace (required) : provide namespace to deploy items"
  echo "    branchname (required) : provide branchname to pick branch config items"
 # echo "    pipeline-selection (optional): pipeline - enterprise pipeline used for environment promotion between OpenShift clusters"
  echo "    side to be deployed (required) : provide sideA or sideB to create build on jenkins"
  echo "                                   If no option specified, builds only in provided sbx namespace"
  # Exit with "Invalid argument" return code.
  exit 22
fi

SOURCE_REPOSITORY_URL=$(git config --get remote.origin.url)
APPLICATION_NAME=omnipro-csstheme
echo "NAMESPACE=${1}" > .openshift/params/git-secret
echo "filter_tags:
  - sbx #sandbox
  - sideA
  - sideB
  - demo

openshift_cluster_content:
- object: git-secret
  content:
  - name: \"create git secret\"
    template: \"{{ inventory_dir }}/../../.openshift/templates/git-secret.yml\"
    params: \"{{ inventory_dir }}/../../.openshift/params/git-secret\"
    tags:
      - sbx
      - sideA
      - sideB
      - demo
- object: deployments
  content:
  - name: \"deploy sbx environment\"
    template: \"{{ inventory_dir }}/../../.openshift/templates/deploy.yml\"
    params: \"{{ inventory_dir }}/../../.openshift/params/deploy-sbx\"
    tags:
      - sbx
- object: jenkins-delta
  content:
  - name: \"deploy delta jenkins image\"
    template: openshift//delta-jenkins-v3-11
    params: \"{{ inventory_dir }}/../../.openshift/params/delta-jenkins\"
    namespace: ${1}
    tags:
      - sbx
      - sideA
      - sideB
- object: builds
  content:
  - name: \"deploy build pipeline to dev\"
    template: \"{{ inventory_dir }}/../../.openshift/templates/build.yml\"
    params: \"{{ inventory_dir }}/../../.openshift/params/build-sbx\"
    tags:
      - sbx
- object: builds
  content:
  -  name: \"deploy build pipeline to dev\"
     template: \"{{ inventory_dir }}/../../.openshift/templates/alldeploy/builda.yml\"
     params: \"{{ inventory_dir }}/../../.openshift/params/dvl/alldeploy/build-dvl\"
     tags:
      - sideA
- object: builds
  content:
  -  name: \"deploy build pipeline to dev\"
     template: \"{{ inventory_dir }}/../../.openshift/templates/alldeploy/builddemo.yml\"
     params: \"{{ inventory_dir }}/../../.openshift/params/dvl/alldeploy/build-dvl\"
     tags:
      - demo
- object: builds
  content:
  -  name: \"deploy build pipeline to dev\"
     template: \"{{ inventory_dir }}/../../.openshift/templates/alldeploy/buildb.yml\"
     params: \"{{ inventory_dir }}/../../.openshift/params/dvl/alldeploy/build-dvl\"
     tags:
      - sideB
- object: route
  content:
  - name: \"create route\"
    template: \"{{ inventory_dir }}/../../.openshift/templates/route.yml\"
    params: \"{{ inventory_dir }}/../../.openshift/params/route-sbx\"
    tags:
      - sbx
    " > .applier/inventory/group_vars/seed-hosts.yml
ansible-galaxy install -r .applier/requirements.yml --roles-path=galaxy
if [ "$3" = "sideA" ]
then
echo "I am running under pipeline and sideA"
	echo "NAMESPACE=${1}
APPLICATION_NAME=${APPLICATION_NAME}
NGINX_VERSION=1
SOURCE_REPOSITORY_URL=${SOURCE_REPOSITORY_URL}
SOURCE_REPOSITORY_REF=${2}
PIPELINE_SCRIPT=Jenkinsfile" > .openshift/params/dvl/alldeploy/build-dvl
echo "APPLICATION_NAME=${APPLICATION_NAME}-dvla
NAMESPACE=${1}
READINESS_RESPONSE=Alive
MEMORY_LIMIT=256Mi
VERSION=v1
APIURL=http://resomnipro-custdashboardbff-dvla.res-omnipro-dvl.svc:8443/" > .openshift/params/dvl/alldeploy/deploy-dvla
echo "NAMESPACE=${1}" > .openshift/params/git-secret
echo "APPLICATION_NAME=${APPLICATION_NAME}
NAMESPACE=${1}
HOSTNAME_HTTP=cdbfrn-res-omnipro-dvla.dvl1apps.paasdev.delta.com
PATH=/custfrnt" > .openshift/params/dvl/alldeploy/route-dvla
    ansible-playbook -i .applier/inventory/ galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml -e filter_tags=sideA
    echo "Navigate to the OpenShift Console and watch your sandbox deployment."
elif [ "$3" = "sideB" ]
then
	echo "NAMESPACE=${1}
APPLICATION_NAME=${APPLICATION_NAME}
NGINX_VERSION=1
SOURCE_REPOSITORY_URL=${SOURCE_REPOSITORY_URL}
SOURCE_REPOSITORY_REF=${2}
PIPELINE_SCRIPT=Jenkinsfile" > .openshift/params/dvl/alldeploy/build-dvl
echo "APPLICATION_NAME=${APPLICATION_NAME}-dvlb
NAMESPACE=${1}
READINESS_RESPONSE=Alive
MEMORY_LIMIT=256Mi
VERSION=v2
APIURL=http://resomnipro-custdashboardbff-dvla.res-omnipro-dvl.svc:8443/"> .openshift/params/dvl/alldeploy/deploy-dvlb
echo "NAMESPACE=${1}" > .openshift/params/git-secret
echo "APPLICATION_NAME=${APPLICATION_NAME}
NAMESPACE=${1}
HOSTNAME_HTTP=cdbfrn-res-omnipro-dvlb.dvl1apps.paasdev.delta.com
PATH=/custfrnt" > .openshift/params/dvl/alldeploy/route-dvlb
    ansible-playbook -i .applier/inventory/ galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml -e filter_tags=sideB
    echo "Navigate to the OpenShift Console and watch your sandbox deployment."
elif [ "$3" = "sbx" ]
then
echo "NAMESPACE=${1}
APPLICATION_NAME=${APPLICATION_NAME}
NGINX_VERSION=1.14
SOURCE_REPOSITORY_URL=${SOURCE_REPOSITORY_URL}
SOURCE_REPOSITORY_REF=${2}
PIPELINE_SCRIPT=Jenkinsfile-sbx"> .openshift/params/build-sbx

echo "NAMESPACE=${1}
APPLICATION_NAME=${APPLICATION_NAME}
READINESS_RESPONSE=Alive
MEMORY_LIMIT=256Mi
VERSION=latest" > .openshift/params/deploy-sbx

echo "NAMESPACE=${1}" > .openshift/params/git-secret

echo "NAMESPACE=${1}
APPLICATION_NAME=${APPLICATION_NAME}
HOSTNAME_HTTP=csstheme-${1}.sbx2apps.paasdev.delta.com" > .openshift/params/route-sbx

ansible-playbook -i .applier/inventory/ galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml -e filter_tags=sbx
    echo "Navigate to the OpenShift Console and watch your deployment."
elif [ "$3" = "demo" ]
then
	echo "APPLICATION_NAME=${APPLICATION_NAME}-demo
NAMESPACE=${1}
SOURCE_REPOSITORY_URL=${SOURCE_REPOSITORY_URL}
SOURCE_REPOSITORY_REF=${2}
PIPELINE_SCRIPT=Jenkinsfile-demo" > .openshift/params/dvl/alldeploy/build-dvl
ansible-playbook -i .applier/inventory/ galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml -e filter_tags=demo
fi
echo "Navigate to the OpenShift Console and watch your deployment."