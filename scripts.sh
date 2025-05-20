#!/bin/bash
# Script to create all VPC networks and subnets for the project

echo "Creating mynetwork (Auto mode network)..."
gcloud compute networks create mynetwork --subnet-mode=auto

echo "Creating firewall rules for mynetwork..."
gcloud compute firewall-rules create mynetwork-allow-icmp --direction=INGRESS --priority=65534 --network=mynetwork --action=ALLOW --rules=icmp --source-ranges=0.0.0.0/0
gcloud compute firewall-rules create mynetwork-allow-ssh --direction=INGRESS --priority=65534 --network=mynetwork --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0
gcloud compute firewall-rules create mynetwork-allow-rdp --direction=INGRESS --priority=65534 --network=mynetwork --action=ALLOW --rules=tcp:3389 --source-ranges=0.0.0.0/0
gcloud compute firewall-rules create mynetwork-allow-custom --direction=INGRESS --priority=65534 --network=mynetwork --action=ALLOW --rules=all --source-ranges=10.128.0.0/9

echo "Creating VM instances in mynetwork..."
gcloud compute instances create mynet-us-vm \
    --zone=us-central1-a \
    --machine-type=e2-micro \
    --subnet=mynetwork \
    --image-family=debian-12 \
    --image-project=debian-cloud \
    --boot-disk-size=10GB \
    --boot-disk-type=pd-standard

gcloud compute instances create mynet-eu-vm \
    --zone=europe-west1-b \
    --machine-type=e2-micro \
    --subnet=mynetwork \
    --image-family=debian-12 \
    --image-project=debian-cloud \
    --boot-disk-size=10GB \
    --boot-disk-type=pd-standard

echo "Converting mynetwork to custom mode..."
gcloud compute networks update mynetwork --switch-to-custom-subnet-mode

echo "Creating managementnet (Custom mode network)..."
gcloud compute networks create managementnet --subnet-mode=custom

echo "Creating subnet for managementnet..."
gcloud compute networks subnets create managementsubnet-us \
    --network=managementnet \
    --region=us-central1 \
    --range=10.240.0.0/20

echo "Creating firewall rules for managementnet..."
gcloud compute firewall-rules create managementnet-allow-icmp-ssh-rdp \
    --direction=INGRESS \
    --priority=1000 \
    --network=managementnet \
    --action=ALLOW \
    --rules=icmp,tcp:22,tcp:3389 \
    --source-ranges=0.0.0.0/0

echo "Creating VM instance in managementnet..."
gcloud compute instances create managementnet-us-vm \
    --zone=us-central1-a \
    --machine-type=e2-micro \
    --subnet=managementsubnet-us \
    --image-family=debian-12 \
    --image-project=debian-cloud \
    --boot-disk-size=10GB \
    --boot-disk-type=pd-standard

echo "Creating privatenet (Custom mode network)..."
gcloud compute networks create privatenet --subnet-mode=custom

echo "Creating subnets for privatenet..."
gcloud compute networks subnets create privatesubnet-us \
    --network=privatenet \
    --region=us-central1 \
    --range=172.16.0.0/24

gcloud compute networks subnets create privatesubnet-eu \
    --network=privatenet \
    --region=europe-west1 \
    --range=172.20.0.0/20

echo "Creating firewall rules for privatenet..."
gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp \
    --direction=INGRESS \
    --priority=1000 \
    --network=privatenet \
    --action=ALLOW \
    --rules=icmp,tcp:22,tcp:3389 \
    --source-ranges=0.0.0.0/0

echo "Creating VM instance in privatenet..."
gcloud compute instances create privatenet-us-vm \
    --zone=us-central1-a \
    --machine-type=e2-micro \
    --subnet=privatesubnet-us \
    --image-family=debian-12 \
    --image-project=debian-cloud \
    --boot-disk-size=10GB \
    --boot-disk-type=pd-standard

echo "All networks, subnets, firewall rules, and VM instances have been created!"
