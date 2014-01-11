# Install common stuff
include_recipe "mcollective_test::default"

include_recipe "yum::epel"
package "redis"
service "redis" do
  action :start
end
