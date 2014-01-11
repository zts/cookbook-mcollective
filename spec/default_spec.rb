require 'spec_helper'

describe 'mcollective::default' do
  let(:chef_run) { ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3').converge(described_recipe) }

  it 'includes the client and server recipes' do
    expect(chef_run).to include_recipe "mcollective::server"
    expect(chef_run).to include_recipe "mcollective::client"
  end
end
