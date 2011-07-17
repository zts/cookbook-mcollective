#
# Cookbook Name:: mcollective
# Recipe:: common
#
# Resources required by both client and server.
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

package "mcollective-common" do
  action :install
end
