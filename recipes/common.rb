#
# Cookbook Name:: mcollective
# Recipe:: common
#
# Resources required by both client and server.
#
# Copyright 2011, Zachary Stevens
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

# Install common components
include_recipe node['mcollective']['recipes']['install_common']

# directory for unpackaged plugins (extra mcollective libdir)
remote_directory node['mcollective']['site_plugins'] do
  source 'plugins'
  owner 'root'
  group 'root'
  files_owner 'root'
  files_group 'root'
  mode "0755"
  recursive true
end

# directory for per-plugin configuration (plugin.d)
directory node['mcollective']['plugin_conf'] do
  owner "root"
  group "root"
  mode 00755
  action :create
end

## plugin configuration files
# stomp connector
template "#{node['mcollective']['plugin_conf']}/stomp.cfg" do
  source "plugin-stomp.cfg.erb"
  mode 0600
  variables :stomp => node['mcollective']['stomp']
end

# activemq connector
template "#{node['mcollective']['plugin_conf']}/activemq.cfg" do
  source "plugin-activemq.cfg.erb"
  mode 0600
  variables :stomp => node['mcollective']['stomp']
end

# rabbitmq connector
template "#{node['mcollective']['plugin_conf']}/rabbitmq.cfg" do
  source "plugin-rabbitmq.cfg.erb"
  mode 0600
  variables :stomp => node['mcollective']['stomp'],
            :rabbitmq => node['mcollective']['rabbitmq']
end
