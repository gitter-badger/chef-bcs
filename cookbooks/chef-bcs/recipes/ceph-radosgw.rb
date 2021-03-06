#
# Author:: Chris Jones <cjones303@bloomberg.net>
# Cookbook Name:: chef-bcs
# Recipe:: ceph-rgw
#
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

# This is one way to set node default values within a higher level area. However, role default or override
# attribute values are normally a better choice but in this case we want to set the 'rgw dns name' from
# another node attribute value.

# This recipe sets up ceph rgw configuration information needed by the ceph cookbook recipes
node.default['ceph']['config']['rgw']['rgw dns name'] = node['chef-bcs']['domain_name']

# FirewallD rules for radosgw
# open standard http port to tcp traffic only; insert as first rule
# 443 is not required since civetweb does not terminate SSL. Use anyone of the following to terminate SSL traffic:
# Hardware load balancer
# Software load balancer
# Proxy like NGINX or something that can terminate SSL and then proxy on to rgw
# Can also tighten even further by only allowing traffic from upstream load balancer etc...
firewall_rule 'http' do
  port     80
  protocol :tcp
  position 1
  command :allow
end
