#!/bin/bash
#
# Author: Chris Jones <cjones303@bloomberg.net>
# Copyright 2015, Bloomberg Finance L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
set -e

# Clone VMs to make working on Chef portion faster. No need to rebuild. Instead, run vbox_reverse_cloning_vms.sh

export REPO_ROOT=$(git rev-parse --show-toplevel)

source $REPO_ROOT/bootstrap/vms/vbox_functions.sh
source $REPO_ROOT/bootstrap/vms/ceph_chef_hosts.env
source $REPO_ROOT/bootstrap/vms/ceph_chef_adapters.env
source $REPO_ROOT/bootstrap/vms/ceph_chef_bootstrap.env

# IMPORTANT: This file is currently called in vbox_functions in the function called config_networks
# It's done there for now because it already has the VMs down for network adapters so it made since
# to put it there so that we would not have to shutdown the vms again.

#shutdown_vms

vm_dir=$(vbox_dir)
# Items that need addressing...
controller="SATA Controller"
dev=0
# port
#disk_file

echo "Starting drive attachment..."

#for vm in ${CEPH_OSD_HOSTS[@]}; do
for vm in ceph-vm1 ceph-vm2 ceph-vm3; do
  echo $vm
  #count=0
  #for i in $(seq 0 $CEPH_OSD_DRIVES); do
  for i in $(seq 0 3); do
    vbox_delete_hdd $vm "$controller" $dev $((3+$i)) "$vm_dir/$vm/$vm-osd-$i.vdi"
    vbox_create_hdd "$vm_dir/$vm/$vm-osd-$i.vdi" 20480
    vbox_add_hdd $vm "$controller" $dev $((3+$i)) "$vm_dir/$vm/$vm-osd-$i.vdi"
    #count=`expr $count + 1`
  done
  
  # Add Journal drive
  vbox_delete_hdd $vm "$controller" $dev 10 "$vm_dir/$vm/$vm-osd-journal.vdi"
  vbox_create_hdd "$vm_dir/$vm/$vm-osd-journal.vdi" 20480
  vbox_add_hdd $vm "$controller" $dev 10 "$vm_dir/$vm/$vm-osd-journal.vdi"
done

#start_vms
#source $REPO_ROOT/bootstrap/vms/vagrant/vagrant_mount_vms.sh
