#
# Cookbook Name:: mcollective
# Recipe:: client
#
# Copyright 2011, Zachary Stevens
#
# All rights reserved - Do Not Redistribute
#

include_recipe "mcollective::common"

package "mcollective-client" do
  action :install
end

template "/etc/mcollective/client.cfg" do
  source "client.cfg.erb"
  mode 0644
end
