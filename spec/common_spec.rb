require 'spec_helper'

describe 'mcollective::common' do
  let(:chef_run) { ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3').converge(described_recipe) }

  it "sets the default attributes" do
    expect(chef_run.node['mcollective']['site_plugins']).to be
    expect(chef_run.node['mcollective']['plugin_conf']).to be
    expect(chef_run.node['mcollective']['users']).to respond_to(:each)
  end
end
