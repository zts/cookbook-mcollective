require 'spec_helper'

describe 'mcollective::server' do
  let(:chef_run) { ChefSpec::SoloRunner.new(:platform => 'redhat', :version => '6.3').converge(described_recipe) }

  it 'installs mcollective' do
    expect(chef_run).to install_package('mcollective')
    expect(chef_run).to install_package('mcollective-common')
  end

  it 'writes /etc/mcollective/server.cfg' do
    expect(chef_run).to render_file('/etc/mcollective/server.cfg')
  end

  it 'updates to server.cfg notify the service to restart' do
    resource = chef_run.template('/etc/mcollective/server.cfg')
    expect(resource).to notify('service[mcollective]').to(:restart)
  end

  it 'sets the default PSK callertype' do
    expect(chef_run).to render_file('/etc/mcollective/server.cfg')
      .with_content(/plugin.psk.callertype = uid/)
  end

  it 'registers the chef handler' do
    expect(chef_run).to enable_chef_handler('MCollective::ClassList')
  end

  it 'installs the opscodeohai plugin' do
    expect(chef_run).to create_cookbook_file('/etc/mcollective/site_plugins/mcollective/facts/opscodeohai_facts.rb')
  end
  it 'updates to the opscodeohai plugin do not notify the service to restart' do
    resource = chef_run.cookbook_file('/etc/mcollective/site_plugins/mcollective/facts/opscodeohai_facts.rb')
    expect(resource).not_to notify('service[mcollective]')
  end

  context 'when configured not to install the chef handler' do
    let(:chef_run) {
      chef_run = ChefSpec::SoloRunner.new(:platform => 'redhat', :version => '6.3')
      chef_run.node.override['mcollective']['install_chef_handler?'] = false
      chef_run.converge(described_recipe)
    }

    it 'does not register the chef handler' do
      expect(chef_run).not_to enable_chef_handler('MCollective::ClassList')
    end
  end

  context 'when configured to use the opscodeohai fact source' do
    let(:chef_run) {
      chef_run = ChefSpec::SoloRunner.new(:platform => 'redhat', :version => '6.3')
      chef_run.node.override['mcollective']['factsource'] = 'ohai'
      chef_run.converge(described_recipe)
    }

    it 'installs the opscodeohai plugin' do
      expect(chef_run).to create_cookbook_file('/etc/mcollective/site_plugins/mcollective/facts/opscodeohai_facts.rb')
    end
    it 'updates to the opscodeohai plugin notify the service to restart' do
      resource = chef_run.cookbook_file('/etc/mcollective/site_plugins/mcollective/facts/opscodeohai_facts.rb')
      expect(resource).to notify('service[mcollective]').to(:restart)
    end
  end

  context 'configured to use activemq' do
    let(:chef_run) {
      chef_run = ChefSpec::SoloRunner.new(:platform => 'redhat', :version => '6.3')
      chef_run.node.override['mcollective']['connector'] = 'activemq'
      chef_run.node.override['mcollective']['stomp']['hostname'] = 'testhost'
      chef_run.node.override['mcollective']['stomp']['port'] = '12345'
      chef_run.node.override['mcollective']['stomp']['username'] = 'testuser'
      chef_run.node.override['mcollective']['stomp']['password'] = 'testpass'
      chef_run.converge(described_recipe)
    }

    it 'sets the connector in server.cfg' do
      expect(chef_run).to render_file('/etc/mcollective/server.cfg')
        .with_content(/connector = activemq/)
    end
    it 'writes the activemq credentials in the server config' do
      words = %w{testuser testpass}
      words.each do |word|
        expect(chef_run).to render_file('/etc/mcollective/server.cfg')
          .with_content(/plugin.activemq.*#{word}/)
      end
    end
  end

  context 'configured to use rabbitmq' do
    let(:chef_run) {
      chef_run = ChefSpec::SoloRunner.new(:platform => 'redhat', :version => '6.3')
      chef_run.node.override['mcollective']['connector'] = 'rabbitmq'
      chef_run.node.override['mcollective']['stomp']['hostname'] = 'testhost'
      chef_run.node.override['mcollective']['stomp']['port'] = '12345'
      chef_run.node.override['mcollective']['stomp']['username'] = 'testuser'
      chef_run.node.override['mcollective']['stomp']['password'] = 'testpass'
      chef_run.converge(described_recipe)
    }

    it 'sets the connector in server.cfg' do
      expect(chef_run).to render_file('/etc/mcollective/server.cfg')
        .with_content(/connector = rabbitmq/)
    end
    it 'writes the rabbitmq credentials in the server config' do
      words = %w{testuser testpass}
      words.each do |word|
        expect(chef_run).to render_file('/etc/mcollective/server.cfg')
          .with_content(/plugin.rabbitmq.*#{word}/)
      end
    end
  end

  context 'configured to use redis' do
    let(:chef_run) {
      chef_run = ChefSpec::SoloRunner.new(:platform => 'redhat', :version => '6.3')
      chef_run.node.override['mcollective']['connector'] = 'redis'
      chef_run.node.override['mcollective']['redis']['hostname'] = 'testhost'
      chef_run.node.override['mcollective']['redis']['port'] = '12345'
      chef_run.node.override['mcollective']['redis']['db'] = '1'
      chef_run.node.override['mcollective']['site_plugins'] = "/etc/mcollective/site_plugins/mcollective"
      chef_run.converge(described_recipe)
    }

    it 'sets the connector in server.cfg' do
      expect(chef_run).to render_file('/etc/mcollective/server.cfg')
        .with_content(/connector = redis/)
    end
  end
end
