#
# Cookbook Name:: mcollective
# Recipe:: common
#
# Resources required by both client and server.
#
# Copyright 2011, Zachary Stevens
#
# Licensed under the Apache License, Version 2.0 (the "License");
#

package "rubygems" do
  action :install
end

case node['platform']
when "ubuntu","debian"
  apt_repository "puppetlabs" do
    uri "http://apt.puppetlabs.com/ubuntu"
    components ["lucid","main"]
    key "4BD6EC30"
    keyserver "pgp.mit.edu"
    action :add
  end

  package "libstomp-ruby" do
    action :install
  end
when "centos","redhat","fedora"
  yum_key "RPM-GPG-KEY-puppetlabs" do
    url "http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs"
    action :add
  end
  
  yum_repository "puppetlabs" do
    name "puppetlabs"
    description "Puppet Labs Packages"
    url "http://yum.puppetlabs.com/base/"
    action :add
  end

  package "rubygem-stomp" do
    action :install
  end
end

package "mcollective-common" do
  action :install
end
