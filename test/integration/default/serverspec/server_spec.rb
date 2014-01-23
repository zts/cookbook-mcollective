require 'spec_helper'

# The server recipe should enable a chef handler, which writes out the
# YAML factfile.  Among other things, it should include the hostname.
describe file('/etc/mcollective/facts.yaml') do
  it {
    should be_file
    should be_mode '444'
  }
  thishost = `hostname`.chomp
  its(:content) { should match /hostname: #{thishost}/ }
end

# The mcollective server should be configured to use the YAML fact
# source
describe file('/etc/mcollective/server.cfg') do
  it {
    should be_file
    should be_mode '600'
  }
  thishost = `hostname`
  its(:content) {
    should match /factsource = yaml/
  }
  its(:content) {
    should match "plugin.yaml = /etc/mcollective/facts.yaml"
  }
end

# The mcollective server should be running
describe service('mcollective') do
  it {
    should be_running
  }
end
