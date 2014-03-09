#
# Cookbook Name:: mcollective
# Recipe:: server
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

# Ensure common components are installed
include_recipe "mcollective::common"

# Install server components
include_recipe node['mcollective']['recipes']['install_server']

service "mcollective" do
  supports :restart => true, :status => true
  action [:enable, :start]
end

# Restart mcollective if the chef agent changes
if node['mcollective']['install_chef_agent?']
  ['rb', 'ddl'].each do |ext|
    r = resources("cookbook_file[#{node['mcollective']['site_plugins']}/agent/chef.#{ext}]")
    r.notifies :restart, "service[mcollective]"
  end
end

# The libdir paths in the MC configuration need to omit the
# trailing "/mcollective"
site_libdir = node['mcollective']['site_plugins'].sub(/\/mcollective$/, '')
template "/etc/mcollective/server.cfg" do
  source "server.cfg.erb"
  mode 0600
  notifies :restart, 'service[mcollective]'
  variables :site_plugins => site_libdir,
            :config       => node['mcollective']
end

cookbook_file "#{node['mcollective']['site_plugins']}/facts/opscodeohai_facts.rb" do
  source "opscodeohai_facts.rb"
  mode 0644
  notifies :restart, 'service[mcollective]' if node['mcollective']['factsource'] == 'ohai'
end

if node['mcollective']['install_chef_handler?']
  include_recipe "chef_handler"

  cookbook_file "#{node['chef_handler']['handler_path']}/mcollective_classlist.rb" do
    source "mcollective_classlist.rb"
    mode 0644
  end

  chef_handler "MCollective::ClassList" do
    source "#{node['chef_handler']['handler_path']}/mcollective_classlist.rb"
    supports :report => true, :exception => false
    action :enable
  end
end
