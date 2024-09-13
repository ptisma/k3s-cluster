## Longhorn

### Motivation
The default k3's storage provisioner is rancher.io/local-path which persists the volumes locally on the node's filesystem itself:  /var/lib/rancher/k3s/storage/.

Since I am using the multi-node cluster I want my storage to be distributed: k3s doesn’t replicate or share the data across nodes which means if the pod is moved (or rescheduled) to a different node (due to node failure, maintenance, etc.), it will no longer have access to the original node's local storage.

### What is Longhorn?
Longhorn is a distributed block storage system for Kubernetes applications. It is designed to provide reliable, performant, and persistent storage for stateful applications running in Kubernetes clusters.
Longhorn distributes block storage across multiple nodes in a Kubernetes cluster, providing redundancy and fault tolerance.

Longhorn creates a dedicated storage controller for each block device volume and synchronously replicates the volume across multiple replicas stored on multiple nodes. The storage controller and replicas are themselves orchestrated using Kubernetes.


### Longhorn's architecture on Kubernetes
It's split in two parts: control plane and data plane. Control plane controls how data is stored, replicated, and managed across the nodes in the Kubernetes cluster. The data plane is responsible for the actual handling of data read/write operations. It provides the mechanism for storing, replicating, and serving the data to workloads in Kubernetes.

Control plane is the Longhorn Manager pod, part of the daemon set, which runs on every node in the operator pattern fashion: it is responsible for creating and managing volumes in the Kubernetes cluster, and handles the API calls from the UI or the volume plugins for Kubernetes.

Once the Longhorn Manager is asked to create the a volume, it creates a Longhorn Engine instance on the node the volume is attached to, and it creates a replica on each node where a replica will be placed. The Engine and replicas are part of the data plane.

The engine instance is responsible for managing the actual I/O to the volume. It doesn’t store data itself but rather coordinates the read/write operations across the replicas.

The replica instances handle the actual data storage. Each replica holds a full copy of the data. Replicas are spread across different nodes to ensure data availability in case of node failure.
Both engine and replica instances are pods as well.

Workflow in practice would look like this:
- pod uses a PVC to request storage
- CSI controller pod communicates with the Kubernetes API and Longhorn to provision a volume based on the PVC. It asks the Longhorn Manager pod to create a volume
- Longhorn Manager pod sets up a Longhorn engine pod (controller) for the volume and schedules the required replica pods to store data on multiple nodes
- When a pod is scheduled to a node, the CSI node plugin pod on that node ensures that the Longhorn volume is attached to the node and mounted to the correct path inside the pod’s filesystem.
- Once the volume is attached, the Longhorn engine manages the I/O operations between the application and the replica pods. It ensures that reads/writes happen in sync with all replicas, maintaining consistency and availability.
- When the pod is terminated, the CSI driver pod instructs the Longhorn pod engine to detach the volume from the node, and the volume becomes available for use by other pods (or can be deleted if necessary).

From application pod's perspective it's just a normal interaction with the mounted device, its the Longhorn engine which intercepts the read/write calls on this block device and replicates the changes to replica pods elsewhere.

PV mounted inside the pod acts as a virtual block device, it is backed by the physical data stored in the replica pods on various nodes. It is somewhat analogous to how NFS works as well since both Longhorn and NFS involve accessing data that is physically stored on a different machine or node from where the pod or client resides and both systems provide a mechanism to mount storage into the pod, allowing the pod to read from and write to the volume or file system as if it were local.

Key Differences are in replication and redundancy: Longhorn handles data replication across multiple replica pods for high availability and resilience. NFS typically relies on a single server or a clustered NFS setup, which may not be as inherently resilient as Longhorn’s replication.
Longhorn is tightly integrated with Kubernetes, providing dynamic provisioning, scaling, and management of storage volumes. NFS is more of a traditional network file system and does not inherently integrate with Kubernetes storage management features.

### Snapshots and backups
Longhorn also supports snapshots and backups.

Snapshots are a point-in-time copy of a volume. It's local to the cluster and is designed to be a quick, lightweight way to preserve the state of a volume. They use the Copy-on-Write (CoW) Mechanism: when you create a snapshot, Longhorn doesn't immediately copy all data. Instead, it marks the current state of the volume. Subsequent changes to the volume after the snapshot are saved separately, and the snapshot represents the state before those changes.

Copy-on-Write (CoW) Explained:
Initial Snapshot Creation:
When you create a snapshot in Longhorn, the system doesn't immediately duplicate all the data from the volume. Instead, it simply marks the current state of the volume. At this point, no additional data is copied, and the snapshot only holds metadata pointing to the existing data blocks.

After Snapshot - Writing New Data:
Once the snapshot is taken, any new changes (new writes) made to the volume after that snapshot are written to new data blocks on disk. This is where the Copy-on-Write part comes into play.

When you modify a block of data that was part of the snapshot, Longhorn doesn't overwrite the original block (because that would alter the snapshot). Instead, it copies the original block to a new location, and the changes are written there. The original block remains untouched as part of the snapshot.

Snapshots Reference Unchanged Data:
For any data that hasn’t changed since the snapshot was taken, the snapshot continues to point to the original blocks. This means no new data is stored for that unchanged part of the volume, conserving storage.

Snapshots are incremental.

A backup in Longhorn is a persistent, off-cluster copy of a volume's data, typically stored in an external object storage service (like AWS S3, NFS, or other S3-compatible storage).
Snapshot Dependency: A backup is created from an existing snapshot. When you initiate a backup, Longhorn first creates a snapshot if one does not already exist, and then uploads that snapshot to the backup target (e.g., S3 or NFS).

Stored Externally: Backups are stored outside the Kubernetes cluster, typically in a cloud storage service (AWS S3, or any S3-compatible storage) or on an NFS server. This makes backups more resilient to node or cluster failures.

Incremental Backup: Similar to snapshots, backups are incremental. After the initial full backup, only the changed data is uploaded in subsequent backups. This reduces bandwidth usage and speeds up the backup process.

### Alternatives

Rook (Ceph) and Portworx are more suited for large, enterprise-scale deployments, offering more sophisticated features like multi-region support, disaster recovery, and highly available storage.

OpenEBS offers flexibility with different storage engines but introduces some complexity in deciding the best engine for your use case.

GlusterFS is a good choice for those needing distributed file storage but may not fit well with block storage workloads.

For performance check results here https://medium.com/volterra-io/kubernetes-storage-performance-comparison-v2-2020-updated-1c0b69f0dcf4

For home-lab scenario, the NFS between the k3s nodes would also be "suitable" solution.

