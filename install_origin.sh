#!/bin/bash

MASTER_SSH=vagrant@ose3-master.example.com
REGISTRY_SETUP="sudo oadm policy add-role-to-user system:registry reguser;sudo oadm registry --create=true   --service-account=registry --credentials=/etc/origin/master/openshift-registry.kubeconfig --mount-host=/var/lib/openshift/docker-registry"

magenta=`tput setaf 5; tput bold;`
echo "${magenta}Starting Openshift Origin Cluster                 ..."

vagrant plugin list | grep openstack  > /dev/null
if [ $? != 0 ]; then
  echo "Install Vagrant Openstack Provider [HACK]                 ..."
  vagrant plugin install vagrant-openstack-plugin
  vagrant plugin install vagrant-openstack-provider
  vagrant plugin install vagrant-hostmanager
fi

  
if [ ! -f /usr/local/bin/oc ];then

  echo "Get OC tools for Management                                 ..."
  curl -sS -J -L https://github.com/openshift/origin/releases/download/v1.1/openshift-origin-v1.1-ac7a99a-darwin-amd64.tar.gz -o /tmp/oc-tools.tar.gz
  mkdir -p /tmp/oc-tools
  tar xf /tmp/oc-tools.tar.gz -C /tmp/oc-tools
  echo "Installing OC tools in /usr/local/bin/                      ..."
  cp -r /tmp/oc-tools/o*  /usr/local/bin/

  rm -rf /tmp/oc-tools*

fi

echo "${magenta}Starting Master and Minions                                   ..."
vagrant up --provider=virtualbox

echo ""
echo "${magenta}Setup login: User: admin, Password: admin                     ..."
rm -rf ~/.kube/config

echo ""
echo "${magenta}Copy Master Config: Make life easier                     ..."
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vagrant@ose3-master.example.com:~/.kube/config ~/.kube/config
#oc login -u admin ose3-master.example.com:8443 --insecure-skip-tls-verify=true

echo ""
echo "${magenta}Setup reguser for docker regstery                     ..."
#oadm policy add-role-to-user system:registry reguser
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null  -t $MASTER_SSH '$REGISTRY_SETUP'

echo ""
echo "${magenta}Access Origin : https://ose3-master.example.com:8443/"
