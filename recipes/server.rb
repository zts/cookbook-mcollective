#
# Cookbook Name:: mcollective
# Recipe:: server
#
# Copyright 2011, Zachary Stevens
#
# All rights reserved - Do Not Redistribute
#

include_recipe "mcollective::common"

package "mcollective" do
  action :install
end

service "mcollective" do
  supports :restart => true, :status => true
  action [:enable, :start]
end

template "/etc/mcollective/server.cfg" do
  source "server.cfg.erb"
  mode 0600
  notifies :restart, 'service[mcollective]'
end

cookbook_file "#{node['mcollective']['plugin_path']}/facts/opscodeohai_facts.rb" do
  source "opscodeohai_facts.rb"
  mode 0644
  notifies :restart, 'service[mcollective]'
end

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
