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

# Create a group permitted to read mcollective config
group node['mcollective']['group'] do
  members node['mcollective']['users']
  action :create
end

# directories for unpackaged plugins (extra mcollective libdir)
plugin_types = %w{agent audit connector data facts registration security simplerpc_authorization}
plugin_types.each do |dir|
  directory "#{node['mcollective']['site_plugins']}/#{dir}" do
    owner 'root'
    group 'root'
    mode "0755"
    recursive true
  end
end

# install chef agent
cookbook_file "#{node['mcollective']['site_plugins']}/agent/chef.rb" do
  source "plugins/agent/chef.rb"
  mode '0644'
  if resource(:service => 'mcollective')
    notifies :restart, "service[mcollective]"
  end rescue Chef::Exceptions::ResourceNotFound
  only_if { node['mcollective']['install_chef_agent?'] }
end
cookbook_file "#{node['mcollective']['site_plugins']}/agent/chef.ddl" do
  source "plugins/agent/chef.ddl"
  mode '0644'
  if resource(:service => 'mcollective')
    notifies :restart, "service[mcollective]"
  end rescue Chef::Exceptions::ResourceNotFound
  only_if { node['mcollective']['install_chef_agent?'] }
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
  owner 'root'
  group node['mcollective']['group']
  mode '0640'
  variables :stomp => node['mcollective']['stomp']
end

# activemq connector
template "#{node['mcollective']['plugin_conf']}/activemq.cfg" do
  source "plugin-activemq.cfg.erb"
  owner 'root'
  group node['mcollective']['group']
  mode '0640'
  variables :stomp => node['mcollective']['stomp']
end

# rabbitmq connector
template "#{node['mcollective']['plugin_conf']}/rabbitmq.cfg" do
  source "plugin-rabbitmq.cfg.erb"
  owner 'root'
  group node['mcollective']['group']
  mode '0640'
  variables :stomp => node['mcollective']['stomp'],
            :rabbitmq => node['mcollective']['rabbitmq']
end

# redis connector
if node['mcollective']['connector'] == 'redis'
  # install the connector
  gem_package "redis"
  remote_file "#{node['mcollective']['site_plugins']}/connector/redis.rb" do
    source "https://github.com/ripienaar/mc-plugins/raw/master/connector/redis/redis.rb"
    mode 0644
  end

  # install plugin configuration
  template "#{node['mcollective']['plugin_conf']}/redis.cfg" do
    source "plugin-redis.cfg.erb"
    user 'root'
    group node['mcollective']['group']
    mode '0640'
    variables :redis => node['mcollective']['redis']
  end
end
