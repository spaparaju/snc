#!/bin/bash

set -exuo pipefail

wait_for_api_server()
{
        count=1
        while ! ${OC} api-resources >/dev/null 2>&1; do
                if [ $count -lt 100 ]
                then
                        sleep 3
                        count=`expr $count + 1`
                else
                        exit
                fi
        done
}

delete_pods_for_a_namespace() {
 	${OC} delete pods -n  $1 --all
	sleep 10
	wait_for_api_server
}

## 1
delete_pods_for_a_namespace openshift-authentication  

## 2
delete_pods_for_a_namespace openshift-authentication-operator 
delete_pods_for_a_namespace openshift-cluster-machine-approver 
delete_pods_for_a_namespace openshift-cluster-node-tuning-operator 
delete_pods_for_a_namespace openshift-cluster-samples-operator 
delete_pods_for_a_namespace openshift-config-operator  
delete_pods_for_a_namespace openshift-console 
delete_pods_for_a_namespace openshift-console-operator  

## 3
delete_pods_for_a_namespace openshift-controller-manager  
delete_pods_for_a_namespace openshift-controller-manager-operator  
delete_pods_for_a_namespace openshift-dns
delete_pods_for_a_namespace openshift-dns-operator  
delete_pods_for_a_namespace openshift-image-registry   
delete_pods_for_a_namespace openshift-kube-storage-version-migrator 
#delete_pddods_for_a_namespace openshift-marketplace  
delete_pods_for_a_namespace openshift-multus  
delete_pods_for_a_namespace openshift-network-operator   
#delete_pods_for_a_namespace openshift-operator-lifecycle-manager   
delete_pods_for_a_namespace openshift-sdn   
delete_pods_for_a_namespace openshift-service-ca   
delete_pods_for_a_namespace openshift-service-ca-operator    
delete_pods_for_a_namespace openshift-apiserver  
delete_pods_for_a_namespace openshift-apiserver-operator 
delete_pods_for_a_namespace openshift-ingress 
delete_pods_for_a_namespace openshift-ingress-operator 

delete_pods_for_a_namespace openshift-cluster-version
delete_pods_for_a_namespace openshift-config-operator
delete_pods_for_a_namespace openshift-etcd-operator
delete_pods_for_a_namespace openshift-kube-apiserver-operator
delete_pods_for_a_namespace openshift-kube-controller-manager-operator
delete_pods_for_a_namespace openshift-kube-scheduler-operator
delete_pods_for_a_namespace openshift-oauth-apiserver
#delete_pods_for_a_namespace openshift-monitoring

if [ $PERF_TUNE_DISK_LEVEL -eq 2 ]
then
	delete_pods_for_a_namespace openshift-marketplace  
	delete_pods_for_a_namespace openshift-operator-lifecycle-manager   
	delete_pods_for_a_namespace openshift-monitoring
elif [ $PERF_TUNE_DISK_LEVEL -eq 3 ]
then
	delete_pods_for_a_namespace openshift-monitoring
fi
