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

  context 'configured to use activemq' do
    let(:chef_run) {
      chef_run = ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3')
      chef_run.node.set['mcollective']['connector'] = 'activemq'
      chef_run.node.set['mcollective']['stomp']['hostname'] = 'testhost'
      chef_run.node.set['mcollective']['stomp']['port'] = '12345'
      chef_run.node.set['mcollective']['stomp']['username'] = 'testuser'
      chef_run.node.set['mcollective']['stomp']['password'] = 'testpass'
      chef_run.converge(described_recipe)
    }

    it 'sets the connector in server.cfg' do
      expect(chef_run).to render_file('/etc/mcollective/server.cfg')
        .with_content(/connector = activemq/)
    end
  end

  context 'configured to use rabbitmq' do
    let(:chef_run) {
      chef_run = ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3')
      chef_run.node.set['mcollective']['connector'] = 'rabbitmq'
      chef_run.node.set['mcollective']['stomp']['hostname'] = 'testhost'
      chef_run.node.set['mcollective']['stomp']['port'] = '12345'
      chef_run.node.set['mcollective']['stomp']['username'] = 'testuser'
      chef_run.node.set['mcollective']['stomp']['password'] = 'testpass'
      chef_run.converge(described_recipe)
    }

    it 'sets the connector in server.cfg' do
      expect(chef_run).to render_file('/etc/mcollective/server.cfg')
        .with_content(/connector = rabbitmq/)
    end
  end

  context 'configured to use redis' do
    let(:chef_run) {
      chef_run = ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3')
      chef_run.node.set['mcollective']['connector'] = 'redis'
      chef_run.node.set['mcollective']['redis']['hostname'] = 'testhost'
      chef_run.node.set['mcollective']['redis']['port'] = '12345'
      chef_run.node.set['mcollective']['redis']['db'] = '1'
      chef_run.node.set['mcollective']['site_plugins'] = "/etc/mcollective/site_plugins/mcollective"
      chef_run.converge(described_recipe)
    }

    it 'sets the connector in server.cfg' do
      expect(chef_run).to render_file('/etc/mcollective/server.cfg')
        .with_content(/connector = redis/)
    end
  end
end
