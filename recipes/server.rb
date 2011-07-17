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

cookbook_file "/usr/share/mcollective/plugins/mcollective/facts/opscodeohai_facts.rb" do
  source "opscodeohai_facts.rb"
  mode 0644
  notifies :restart, 'service[mcollective]'
end
