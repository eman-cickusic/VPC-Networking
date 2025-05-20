#!/bin/bash
# Script to test connectivity between VM instances

function get_vm_ip() {
  local vm_name=$1
  local ip_type=$2  # "INTERNAL_IP" or "EXTERNAL_IP"
  
  gcloud compute instances describe $vm_name --zone=us-central1-a --format="get(networkInterfaces[0].$ip_type)"
}

function test_ping() {
  local source_vm=$1
  local target_ip=$2
  local description=$3
  
  echo "Testing ping from $source_vm to $description ($target_ip)..."
  gcloud compute ssh $source_vm --zone=us-central1-a --command="ping -c 3 $target_ip"
  
  if [ $? -eq 0 ]; then
    echo "✅ Ping successful from $source_vm to $description ($target_ip)"
  else
    echo "❌ Ping failed from $source_vm to $description ($target_ip)"
  fi
  echo "------------------------------------------------------"
}

# Get IPs for all VMs
MYNET_US_INT_IP=$(get_vm_ip "mynet-us-vm" "INTERNAL_IP")
MYNET_US_EXT_IP=$(get_vm_ip "mynet-us-vm" "EXTERNAL_IP")
MYNET_EU_INT_IP=$(get_vm_ip "mynet-eu-vm" "INTERNAL_IP")
MYNET_EU_EXT_IP=$(get_vm_ip "mynet-eu-vm" "EXTERNAL_IP")
MGMT_US_INT_IP=$(get_vm_ip "managementnet-us-vm" "INTERNAL_IP")
MGMT_US_EXT_IP=$(get_vm_ip "managementnet-us-vm" "EXTERNAL_IP")
PRIV_US_INT_IP=$(get_vm_ip "privatenet-us-vm" "INTERNAL_IP")
PRIV_US_EXT_IP=$(get_vm_ip "privatenet-us-vm" "EXTERNAL_IP")

echo "========================================================"
echo "TESTING CONNECTIVITY FROM MYNET-US-VM"
echo "========================================================"

# Test connectivity from mynet-us-vm
test_ping "mynet-us-vm" "$MYNET_EU_INT_IP" "mynet-eu-vm internal IP"
test_ping "mynet-us-vm" "$MYNET_EU_EXT_IP" "mynet-eu-vm external IP"
test_ping "mynet-us-vm" "$MGMT_US_INT_IP" "managementnet-us-vm internal IP"
test_ping "mynet-us-vm" "$MGMT_US_EXT_IP" "managementnet-us-vm external IP"
test_ping "mynet-us-vm" "$PRIV_US_INT_IP" "privatenet-us-vm internal IP"
test_ping "mynet-us-vm" "$PRIV_US_EXT_IP" "privatenet-us-vm external IP"

echo "========================================================"
echo "TESTING CONNECTIVITY FROM MANAGEMENTNET-US-VM"
echo "========================================================"

# Test connectivity from managementnet-us-vm
test_ping "managementnet-us-vm" "$MYNET_US_INT_IP" "mynet-us-vm internal IP"
test_ping "managementnet-us-vm" "$MYNET_US_EXT_IP" "mynet-us-vm external IP"
test_ping "managementnet-us-vm" "$PRIV_US_INT_IP" "privatenet-us-vm internal IP"
test_ping "managementnet-us-vm" "$PRIV_US_EXT_IP" "privatenet-us-vm external IP"

echo "========================================================"
echo "TESTING CONNECTIVITY FROM PRIVATENET-US-VM"
echo "========================================================"

# Test connectivity from privatenet-us-vm
test_ping "privatenet-us-vm" "$MYNET_US_INT_IP" "mynet-us-vm internal IP"
test_ping "privatenet-us-vm" "$MYNET_US_EXT_IP" "mynet-us-vm external IP"
test_ping "privatenet-us-vm" "$MGMT_US_INT_IP" "managementnet-us-vm internal IP"
test_ping "privatenet-us-vm" "$MGMT_US_EXT_IP" "managementnet-us-vm external IP"

echo "All connectivity tests completed!"
