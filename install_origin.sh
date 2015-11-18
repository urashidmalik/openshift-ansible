#!/bin/bash

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

echo "Starting Master and Minions                                   ..."
vagrant up --provider=virtualbox

echo ""
echo "Setup login: User: admin, Password: admin                     ..."
oc login ose3-master.example.com:8443 --insecure-skip-tls-verify=true

echo "Setup reguser for docker regstery                     ..."
oadm policy add-role-to-user system:registry reguser

echo "Access Origin : https://ose3-master.example.com:8443/"









#curl https://storage.googleapis.com/kubernetes-release/release/v1.0.6/bin/$(uname | tr '[:upper:]' '[:lower:]'$)/amd64/kubectl -o /usr/local/bin/kubectl
#chmod +x /usr/local/bin/kubectl
#sleep 10
#
#echo "${magenta}Configureing kubectl to talk to newly created Kubernetes/CoreOS Cluster ..."
#kubectl config set-cluster vagrant --server=https://172.17.4.101:443 --certificate-authority=${PWD}/ssl/ca.pem
#kubectl config set-credentials vagrant-admin --certificate-authority=${PWD}/ssl/ca.pem --client-key=${PWD}/ssl/admin-key.pem --client-certificate=${PWD}/ssl/admin.pem --username=vagrnat --password=vagrant --insecure-skip-tls-verify=true
#kubectl config set-context vagrant --cluster=vagrant --user=vagrant-admin
#kubectl config use-context vagrant
#sleep 10
#
#echo "${magenta}Cloning Kubernetes Repo ..."
#cd ../../../
#if [ ! -d "./kubernetes" ]; then
#	git clone git@github.com:urashidmalik/kubernetes.git
#fi
#cd kubernetes
#
#echo "${magenta}Getting kubernetes Dashboard up ..."
#kubectl create -f cluster/addons/kube-ui/kube-ui-rc.yaml --namespace=kube-system
#kubectl create -f cluster/addons/kube-ui/kube-ui-svc.yaml --namespace=kube-system
#sleep 10
#
#echo "${magenta}Getting GuestBook Application up ..."
##kubectl create -f examples/guestbook-go/redis-master-controller.json
##kubectl create -f examples/guestbook-go/redis-master-service.json
##
##kubectl create -f examples/guestbook-go/redis-slave-controller.json
##kubectl create -f examples/guestbook-go/redis-slave-service.json
##kubectl create -f examples/guestbook-go/guestbook-controller.json
##kubectl create -f examples/guestbook-go/guestbook-service.json
#
#echo "${magenta}Access Kubernetes Dashboard : 172.17.4.101:8080/ui/"
#echo "${magenta}Access Guest Book App       : 172.17.4.101:30061"
#
#
##kubectl get rc,svc,po --all-namespaces -o wide
#
