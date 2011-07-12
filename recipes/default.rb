#
# Cookbook Name:: mcollective
# Recipe:: default
#
# Copyright 2011, Zachary Stevens
#
# All rights reserved - Do Not Redistribute
#

package "rubygems" do
  action :install
end

package "libstomp-ruby" do
  action :install
end

case node['platform']
when "ubuntu"
  apt_repository "puppetlabs" do
    uri "http://apt.puppetlabs.com/ubuntu"
    components ["lucid","main"]
    key "4BD6EC30"
    keyserver "pgp.mit.edu"
    action :add
  end
when "centos", "redhat"
  yum_key "RPM-GPG-KEY-puppetlabs" do
    url "http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs"
    action :add
  end
  
  yum_repository "puppetlabs" do
    name "Puppet Labs Packages"
    baseurl "http://yum.puppetlabs.com/base/"
    action :add
  end
end

%w{mcollective-common mcollective-client mcollective}.each do |pkg|
  package pkg do
    action :install
  end
end

service "mcollective" do
  supports :restart => true, :status => true
  action [:enable, :start]
end

template "/etc/mcollective/client.cfg" do
  source "client.cfg.erb"
  mode 0644
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
