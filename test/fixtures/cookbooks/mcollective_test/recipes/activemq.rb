# Install common stuff
include_recipe "mcollective_test::default"

# Install activemq
include_recipe "activemq::default"

version = node['activemq']['version']
activemq_home = "#{node['activemq']['home']}/apache-activemq-#{version}"

# Install a configuration that mcollective can use
cookbook_file "#{activemq_home}/conf/activemq.xml" do
  source "activemq.xml"
  mode "0644"
  owner "root"
  group "root"
  notifies :restart, 'service[activemq]'
end
