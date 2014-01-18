#
# Cookbook Name:: mcollective
# Recipe:: client
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

# Ensure common components have been installed
include_recipe "mcollective::common"

# Install client components
include_recipe node['mcollective']['recipes']['install_client']

# The libdir paths in the MC configuration need to omit the
# trailing "/mcollective"
site_libdir = node['mcollective']['site_plugins'].sub(/\/mcollective$/, '')

template "/etc/mcollective/client.cfg" do
  source "client.cfg.erb"
  owner 'root'
  group  node['mcollective']['group']
  mode '0640'
  variables :site_plugins => site_libdir,
            :config       => node['mcollective']
end
