# VPC Networking

This repository documents my implementation of Google Cloud VPC networks and demonstrates key networking concepts in Google Cloud Platform (GCP).

## Video

https://youtu.be/VwZuw4xU2iE


## Overview

In this project, I created and configured various Virtual Private Cloud (VPC) networks in Google Cloud, following a structured approach to understand:

- Default VPC networks in Google Cloud projects
- Auto mode vs. Custom mode VPC networks
- Firewall rules configuration
- Network connectivity between VM instances
- Multi-network architecture

## Architecture

The implementation includes three VPC networks:

1. **mynetwork** - Initially created as an auto mode network, later converted to custom mode
2. **managementnet** - Custom mode network with specific subnet
3. **privatenet** - Custom mode network with two specific subnets

Each network has its own VM instances and firewall rules to control traffic.

![Network Architecture](images/vpc_architecture.png)

## Implementation Steps

### 1. Explored and Deleted Default Network

- Examined default subnets, routes, and firewall rules
- Deleted default network to understand its importance
- Verified that VM instances cannot be created without a VPC network

### 2. Created Auto Mode Network

- Created "mynetwork" as an auto mode VPC network
- Added firewall rules to allow SSH, ICMP, and RDP ingress traffic
- Created VM instances in different regions on the network
- Tested connectivity between VM instances
- Converted the auto mode network to custom mode

### 3. Created Custom Mode Networks

- Created "managementnet" using Google Cloud Console
- Created "privatenet" using gcloud CLI
- Created subnets with non-overlapping CIDR ranges
- Added firewall rules for each network
- Created VM instances in each network

### 4. Tested Connectivity

- Pinged external IP addresses across all VM instances
- Tested internal connectivity within and across networks
- Confirmed that VM instances in the same network can communicate using internal IPs
- Confirmed that VM instances in different networks cannot communicate using internal IPs without additional configuration

## Key Commands

Here are some of the key gcloud commands used:

```bash
# Create a VPC network
gcloud compute networks create privatenet --subnet-mode=custom

# Create subnets
gcloud compute networks subnets create privatesubnet-us --network=privatenet --region=us-central1 --range=172.16.0.0/24
gcloud compute networks subnets create privatesubnet-eu --network=privatenet --region=europe-west1 --range=172.20.0.0/20

# Create firewall rules
gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0

# Create VM instances
gcloud compute instances create privatenet-us-vm --zone=us-central1-a --machine-type=e2-micro --subnet=privatesubnet-us --image-family=debian-12 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=privatenet-us-vm
```

## Key Learnings

1. VPC networks are global resources with regional subnets
2. Auto mode networks create subnets automatically in each region
3. Custom mode networks give more control over subnet creation
4. Firewall rules control traffic to and from VM instances
5. VM instances in the same VPC network can communicate using internal IPs regardless of zone
6. VM instances in different VPC networks cannot communicate using internal IPs without additional configurations

## Next Steps

- Implement VPC Network Peering to connect different networks
- Set up Private Google Access
- Configure Cloud NAT for outbound connections
- Implement Shared VPC for multi-project scenarios
- Explore hybrid connectivity options (Cloud VPN, Cloud Interconnect)

## Resources

- [Google Cloud VPC Documentation](https://cloud.google.com/vpc/docs)
- [Firewall Rules Overview](https://cloud.google.com/vpc/docs/firewalls)
- [VPC Network Peering](https://cloud.google.com/vpc/docs/vpc-peering)
