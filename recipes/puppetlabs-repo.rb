#
# Cookbook Name:: mcollective
# Recipe:: puppetlabs-repo
#
# Installs the apt/yum repo for Puppetlabs packages.
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

case node['platform_family']
when "debian"
  include_recipe "apt::default"

  apt_repository "puppetlabs" do
    uri "http://apt.puppetlabs.com/"
    components [ node['lsb']['codename'], "main" ]
    key "4BD6EC30"
    keyserver "pgp.mit.edu"
    action :add
  end
  apt_repository "puppetlabs-deps" do
    uri "http://apt.puppetlabs.com/"
    components [ node['lsb']['codename'], "dependencies" ]
    key "4BD6EC30"
    keyserver "pgp.mit.edu"
    notifies :run, "execute[apt-get update]", :immediately
    action :add
  end
when "rhel"
  # Version 3 of the yum cookbook removes the "yum_key" resource,
  # among other changes.  This block assumes that an older version is
  # being used, and switches to the new style if that fails
  begin
    yum_cookbook_3 = false
    yum_key "RPM-GPG-KEY-puppetlabs" do
      url "http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs"
      action :add
    end
  rescue NameError
    yum_cookbook_3 = true
  end

  # on amazon linux, $releasever is "latest", which the repo doesn't support
  if platform?("amazon")
    release = "6Server"
  else
    release = "$releasever"
  end

  yum_repository "puppetlabs" do
    name "puppetlabs"
    description "Puppet Labs Packages"
    url "http://yum.puppetlabs.com/el/#{release}/products/$basearch"
    gpgkey "http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs" if yum_cookbook_3
    action :add
  end

  yum_repository "puppetlabs-deps" do
    name "puppetlabs-deps"
    description "Dependencies for Puppet Labs Software"
    url "http://yum.puppetlabs.com/el/#{release}/dependencies/$basearch"
    gpgkey "http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs" if yum_cookbook_3
    action :add
  end
when "fedora"
  begin
    yum_cookbook_3 = false
    yum_key "RPM-GPG-KEY-puppetlabs" do
      url "http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs"
      action :add
    end
  rescue NameError
    yum_cookbook_3 = true
  end

  yum_repository "puppetlabs" do
    name "puppetlabs"
    description "Puppet Labs Packages"
    url "http://yum.puppetlabs.com/fedora/f$releasever/products/$basearch"
    gpgkey "http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs" if yum_cookbook_3
    action :add
  end
  yum_repository "puppetlabs-deps" do
    name "puppetlabs-deps"
    description "Dependencies for Puppet Labs Software"
    url "http://yum.puppetlabs.com/fedora/$releasever/dependencies/$basearch"
    gpgkey "http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs" if yum_cookbook_3
    action :add
  end
end
