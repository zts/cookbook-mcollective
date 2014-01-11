require 'spec_helper'

describe 'mcollective::server' do
  let(:chef_run) { ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3').converge(described_recipe) }

  it 'installs mcollective' do
    expect(chef_run).to install_package('mcollective')
    expect(chef_run).to install_package('mcollective-common')
  end

  it 'writes /etc/mcollective/server.cfg' do
    expect(chef_run).to render_file('/etc/mcollective/server.cfg')
  end

  it 'notifies the service to restart' do
    resource = chef_run.template('/etc/mcollective/server.cfg')
    expect(resource).to notify('service[mcollective]').to(:restart)
  end

  it 'registers the chef handler' do
    expect(chef_run).to enable_chef_handler('MCollective::ClassList')
  end
end
