#
# Cookbook Name:: nscd
# Recipe:: default
#
# Copyright 2009-2016, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package 'nscd' do
  package_name node['nscd']['package']
  version node['nscd']['version'] unless node['nscd']['version'].nil?
  not_if { platform?('smartos') }
end

template '/etc/nscd.conf' do
  source 'nscd.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    settings: node['nscd'],
    databases: sanitize_databases(node['nscd']['databases'])
  )
  notifies :restart, "service[#{node['nscd']['package']}]"
end

service node['nscd']['package'] do
  service_name 'name-service-cache:default' if platform?('smartos')
  supports restart: true, status: true
  action   [:enable, :start]
end
