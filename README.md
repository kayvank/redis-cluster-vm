# Redis Cluster VM

Create a NixOS VM for redis cluster.

## How do I use it

- Build the vm
- Start the vm
- Create the redis cluster

### Build the VM
To build the VM

``` sh
nix build .#vms.box
```

After a successful build, the result/bin directory will contain an executable script to run the VM using [QEMU](https://www.qemu.org/docs/master/about/index.html#about-qemu) the run the VM.

>[!NOTE]
>  Use port-forwarding to connect to the redis cluster. 
> for detail, see [start-vm.sh](./start-vm.sh)

### Start the VM

To start VM:

``` sh
./start-vm.sh
```
This will start a new VM using QEMU virtualization. 

### Create the redis cluster
>[!NOTE]
> You do not have to use `nix develop` shell if you already have redis-cli available. 

To create the cluster:

``` sh
nix develop
./start-redis-cluster.sh
```

The above command should produce an output similar to:

``` sh
➜  redis-cluster-vm git:(main) ✗ ./start-redis-cluster.sh
>>> Performing hash slots allocation on 6 nodes...
Master[0] -> Slots 0 - 5460
Master[1] -> Slots 5461 - 10922
Master[2] -> Slots 10923 - 16383
Adding replica 127.0.0.1:7004 to 127.0.0.1:7000
Adding replica 127.0.0.1:7005 to 127.0.0.1:7001
Adding replica 127.0.0.1:7003 to 127.0.0.1:7002
>>> Trying to optimize slaves allocation for anti-affinity
[WARNING] Some slaves are in the same host as their master
M: a7fd479d508c51b313e91a1348b80ae0ac26fbd1 127.0.0.1:7000
   slots:[0-5460] (5461 slots) master
M: ccbdb392e63153eabe0a766d05120f72caf8be80 127.0.0.1:7001
   slots:[5461-10922] (5462 slots) master
M: 90921f714eb4fbdd1b7215c75d4f03a2a4ecfca5 127.0.0.1:7002
   slots:[10923-16383] (5461 slots) master
S: eb0a5f87eca6434d927c044d717c02e03618051e 127.0.0.1:7003
   replicates ccbdb392e63153eabe0a766d05120f72caf8be80
S: 206fdfba32f70aea5a1bb58fb784d4aabc850d7e 127.0.0.1:7004
   replicates 90921f714eb4fbdd1b7215c75d4f03a2a4ecfca5
S: 8dbba362f70c7f9857495bd6b18daa15a27bbd0d 127.0.0.1:7005
   replicates a7fd479d508c51b313e91a1348b80ae0ac26fbd1
Can I set the above configuration? (type 'yes' to accept): yes
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join
...
>>> Performing Cluster Check (using node 127.0.0.1:7000)
M: a7fd479d508c51b313e91a1348b80ae0ac26fbd1 127.0.0.1:7000
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
S: eb0a5f87eca6434d927c044d717c02e03618051e 127.0.0.1:7003
   slots: (0 slots) slave
   replicates ccbdb392e63153eabe0a766d05120f72caf8be80
S: 206fdfba32f70aea5a1bb58fb784d4aabc850d7e 127.0.0.1:7004
   slots: (0 slots) slave
   replicates 90921f714eb4fbdd1b7215c75d4f03a2a4ecfca5
M: 90921f714eb4fbdd1b7215c75d4f03a2a4ecfca5 127.0.0.1:7002
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
S: 8dbba362f70c7f9857495bd6b18daa15a27bbd0d 127.0.0.1:7005
   slots: (0 slots) slave
   replicates a7fd479d508c51b313e91a1348b80ae0ac26fbd1
M: ccbdb392e63153eabe0a766d05120f72caf8be80 127.0.0.1:7001
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.

```
