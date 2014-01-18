# Install common stuff
include_recipe "mcollective_test::default"

# Install rabbitmq
package "logrotate"

node.set['rabbitmq']['stomp'] = true
node.set['rabbitmq']['stomp_port'] = node['mcollective']['stomp']['port']
include_recipe "rabbitmq::mgmt_console"

# need to restart rabbit after installing the management plugin
service "rabbitmq-server" do
  action :restart
end

# Configure rabbitmq for mcollective
rabbitmq_user node['mcollective']['stomp']['username'] do
  password node['mcollective']['stomp']['password']
  action :add
end
rabbitmq_user node['mcollective']['stomp']['username'] do
  vhost node['mcollective']['rabbitmq']['vhost']
  permissions ".* .* .*"
  action :set_permissions
end

remote_file "/usr/bin/rabbitmqadmin" do
  source "http://127.0.0.1:15672/cli/rabbitmqadmin"
  retries 5 # instead of retrying, we should wait for rabbitmq to be ready
  mode "755"
  action :create
end
bash "declare mcollective exchanges" do
  user "root"
  code <<-EOF
/usr/bin/rabbitmqadmin declare exchange name=mcollective_broadcast type=topic
/usr/bin/rabbitmqadmin declare exchange name=mcollective_directed type=direct
  EOF
  action :run
end
