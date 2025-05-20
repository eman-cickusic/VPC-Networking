#!/bin/bash
# Script to clean up all resources created in the project

echo "Deleting VM instances..."
gcloud compute instances delete mynet-us-vm mynet-eu-vm managementnet-us-vm privatenet-us-vm --quiet

echo "Deleting firewall rules..."
gcloud compute firewall-rules delete mynetwork-allow-icmp mynetwork-allow-ssh mynetwork-allow-rdp mynetwork-allow-custom managementnet-allow-icmp-ssh-rdp privatenet-allow-icmp-ssh-rdp --quiet

echo "Deleting VPC networks and their subnets..."
gcloud compute networks delete mynetwork managementnet privatenet --quiet

echo "All resources have been deleted!"
