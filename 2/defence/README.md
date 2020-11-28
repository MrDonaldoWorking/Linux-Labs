# Install and mount GlusterFS on CentOS

## There are must be at least two machines connected to each other

One will be server, other will be client

## Connecting two or more virtual machines (VirtualBox):

```shell
VBoxManage dhcpserver add --netname mynetwork --ip 11.11.11.1 --netmask 255.255.255.0 --lowerip 11.11.11.3 --upperip 11.11.11.20 --enable
```

Then attach network adapter to Internal Network with name `mynetwork`

## Checking connection between machines


### 1. Get machine ip address

```shell
ifconfig -a
```
Result:
```
enpOs3: flags=4163<UP,BBOADCAST,RUNNING,MULTICAST> mtu 1500
        inet 11.11.11.4 netmask 255.255.255.0 broadcast 11.11.11.255
        inet6 fe80::a00:27ff:fe38:e6e4 prefixlen 64 scopeid 0x20<link>
        ether 08:00:27:38:e6:e4 txgueuelen 1000 (Ethernet)
        RX packets 1 bytes 590 (590.0 B)
        RX errors 0 dropped 0 overruns 0 frame 0 
        TX packets 70 bytes 6822 (6.6 XIB)
        TX errors 0 dropped 0 overruns 0 carrier 0 collisions 0 

lo: flags=73<UP,LOOPBACE,BUNNING> mtu 65536
        inet 127.0.0.1 netmask 255.0.0.0
        inet6 ::1 prefixlen 128 scopeid 0x10<host>
        loop txqueuelen 1000 (Local Loopback)
        RX packets 158 bytes 20750 (20.2 X1B)
        RX errors 0 dropped 0 overruns 0 frame 0
        TX packets 158 bytes 20750 (20.2 XiB)
        TX errors 0 dropped 0 overruns 0 carrier 0 collisions 0 
```

### 2. Write into `/etc/hosts` ip addresses of server machines

```
127.0.0.1   gluster1 localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost4 localhost4.localdomain4

11.11.11.4  gluster1.example.com gluster1
11.11.11.3  gluster2.example.com gluster2
```

### 3. Checking connection between machines

```shell
ping gluster2
```
Result:
```
gluster2.example.com (11.11.11.3) 56(84) bytes of data.
64 bytes from gluster2.example.com (11.11.11.3): icmp_seq=1 tt1=64 time=0.690 ms 
64 bytes from gluster2.example.com (11.11.11.3): icmp_seq=2 tt1=64 time=0.829 ms
64 bytes from gluster2.example.com (11.11.11.3): icmp_seq=3 tt1=64 time=0.784 ms
^C
--- gluster2.example.com ping statistics ---
3 packets transmitted, 3 received, O% packet loss, time 36ms
rtt min/aug/max/mdev = 0.690/0.767/0.829/0.066 ms
```

## GlusterFS setting and runningsSteps

### 1

On each machines

```shell
yum install -y centos-release-gluster
```

### 2

check file /etc/yum.repos.d/CentOS-GLuster-{CentOS version}.repo:
if file is like this:
    ...
    [centos-gluster{CentOS-version}-test]
    ...
    enabled=1
then set file:
    ...
    [centos-gluster{CentOS-version}]
    ...
    enabled=1
    ...
    [centos-gluster{CentOS-version}-test]
    ...
    enabled=0
because test version is unstable

### 3

On server machines:
```shell
yum install -y glusterfs-server
```

On client machines:
```shell
yum install -y glusterfs-client
```

### 4

Start GlusterFS service:
```shell
systemctl start glusterd
```

Checking status:
```shell
systemctl status glusterd
```

### 5 (if more than one server machine)

Connect server machines to make storage pool:
```shell
gluster peer proble <other_server_machine>
```

If peers couldn't connect to each other, firewall should be disabled:
```shell
systemctl stop firewalld
systemctl disable firewalld
```

### 6

Creating replicated volume on server machine:
```shell
gluster volume create volume1 replica 2 gluster1:{directory}/brick1 gluster2:{directory}/brick1
```

`{directory}` must not be in root partition (otherwise type `force`)

Checking volume commands:
```shell
gluster volume list
gluster volume info volume1
gluster volume status

netstat -nltp
```

### 7

Creating distributed volume on server machine:
```shell
gluster volume create volume2 gluster1:{directory}/brick2 gluster2:{directory}/brick2
```

`{directory}` must not be in root partition (otherwise type `force`)

### 8

Mount volume on client machine:
```shell
mount -t glusterfs gluster1:volume1 /mnt/volume1
```

Check if mounted:
```shell
mount | grep volume
```

## Experimantal part

### Creating file on replicated volume

Files created by client must be on every server machines

### Creating file on distributed volume

Files created by client are in different server machines

## Literature

[GlusterFS Storage for Beginners](https://www.youtube.com/playlist?list=PL34sAs7_26wOwCvth-EjdgGsHpTwbulWq)
