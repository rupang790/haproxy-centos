# haproxy-centos
This is a helm chart for HaProxy deployment based on haproxy-centos-image.

## Description
This helm chart was considered to deploy the `haproxy` container for loadbalancing on each site. This is considered to provide loadbalancing with `bind9-centos7` deployment. The concept is started from that separating the network by 2 different networks as management network and service network, and operating workers(nodes) site-by-site on a Cluster. It means that cluster network by CNIs are using only for management of cluster and all application service will use additional network such as SR-IOV and macvlan created by Multus.

+ Management Network: The network which was CNI plugin installed such as calico, flanel and openshift-sdn on openshift and okd cluster. It means that applications will not used ingress or egress by CNI plugins.
+ Service Network: The network for application services which is using IP based service, and it created with additional physical network interface by Multus.

Network environment, especially IP addresses will be different on each site, so HaProxy configuration should be configured site-by-site. For that, haproxy configuration can be delivered for each site with separate directory.

## Configuration
Additional Network by Multus is not contained on Chart. Because on helm, Network-attachment-definition object is not recognized as resource. So that Network-attachment-definition would be created after deployment, and deployment was not deployed because of no network-attachment-definition resource. (If I am wrong, please comment for it.)
For the test, nginx deployment is included on the chart. It can be enabled when install this chart with `--set` option. If you want to test site-by-site, `nginxTest.podAnnotations` should be modified on `values.yaml`. For now, 4 nginx pods will be deployed once and could reach from each site (So it does not need to deployed twice.)
For now, it can be installed only for 2 different site's configuration as `test` and `pangyo`, but additional sites can be configured with modification of chart.
It also contains logging of haproxy with `rsyslog` and the logs will be logged on directory `/haproxy/log/` on container which mounting volume is necessary. For that, NFS PV and PVC will be deployed when you install the chart.

## Installation
Before installation, there is prerequested things.
+ Please move the configuration files by each site's directory.
  + `/etc/haproxy/haproxy.cfg` files should saved on `haproxy/[SITE_NAME]/` directory.
+ Add label on each workers(nodes) to recognize the site.
  + For 'test' site: `oc labels node worker01 location-node=test`
  + For 'pangyo' site: `oc labels node worker02 location-node=pangyo`

To install the chart,
```
$ helm install [RELEASE_NAME] [DIRECTORY_PATH_OF_CHART] --set workerLocation=[SITE_NAME],nginxTest.enabled=true
```

If you do not want to install nginx for test, you can just ignore from `--set` option.

Installtion Example:
```
>> For "test" sites with client pod
$ helm install haproxy-test . --set workerLocation=test,nginxTest.enabled=true

>> For "pangyo" sites without client pod
$ helm install haproxy-pangyo . --set workerLocation=pangyo
```
