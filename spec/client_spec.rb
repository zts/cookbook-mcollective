require 'spec_helper'

describe 'mcollective::client' do
  let(:chef_run) { ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3').converge(described_recipe) }

  it 'installs mcollective' do
    expect(chef_run).to install_package('mcollective-client')
  end

  it 'writes /etc/mcollective/client.cfg' do
    expect(chef_run).to render_file('/etc/mcollective/client.cfg')
  end

  it 'sets the default PSK callertype' do
    expect(chef_run).to render_file('/etc/mcollective/client.cfg')
      .with_content(/plugin.psk.callertype = uid/)
  end

  it 'sets the correct permissions on client.cfg' do
    expect(chef_run).to create_template('/etc/mcollective/client.cfg')
      .with(group: 'mcollective', mode: '0640')
  end

  context 'configured to use activemq' do
    let(:chef_run) {
      chef_run = ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3')
      chef_run.node.set['mcollective']['connector'] = 'activemq'
      chef_run.node.set['mcollective']['stomp']['username'] = 'testuser'
      chef_run.node.set['mcollective']['stomp']['password'] = 'testpass'
      chef_run.converge(described_recipe)
    }

    it 'sets the connector in client.cfg' do
      expect(chef_run).to render_file('/etc/mcollective/client.cfg')
        .with_content(/connector = activemq/)
    end
    it 'writes the activemq credentials in the client config' do
      words = %w{testuser testpass}
      words.each do |word|
        expect(chef_run).to render_file('/etc/mcollective/client.cfg')
          .with_content(/plugin.activemq.*#{word}/)
      end
    end

    context 'with client middleware credentials' do
      let(:chef_run) {
        chef_run = ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3')
        chef_run.node.set['mcollective']['connector'] = 'activemq'
        chef_run.node.set['mcollective']['stomp']['username'] = 'testuser'
        chef_run.node.set['mcollective']['stomp']['password'] = 'testpass'
        chef_run.node.set['mcollective']['stomp']['client_username'] = 'clientuser'
        chef_run.node.set['mcollective']['stomp']['client_password'] = 'clientpass'
        chef_run.converge(described_recipe)
      }

      it 'writes the activemq credentials in the client config' do
        words = %w{clientuser clientpass}
        words.each do |word|
          expect(chef_run).to render_file('/etc/mcollective/client.cfg')
            .with_content(/plugin.activemq.*#{word}/)
        end
      end
    end
  end

  context 'configured to use rabbitmq' do
    let(:chef_run) {
      chef_run = ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3')
      chef_run.node.set['mcollective']['connector'] = 'rabbitmq'
      chef_run.node.set['mcollective']['stomp']['username'] = 'testuser'
      chef_run.node.set['mcollective']['stomp']['password'] = 'testpass'
      chef_run.converge(described_recipe)
    }

    it 'sets the connector in client.cfg' do
      expect(chef_run).to render_file('/etc/mcollective/client.cfg')
        .with_content(/connector = rabbitmq/)
    end
    it 'writes the rabbitmq credentials in the client config' do
      words = %w{testuser testpass}
      words.each do |word|
        expect(chef_run).to render_file('/etc/mcollective/client.cfg')
          .with_content(/plugin.rabbitmq.*#{word}/)
      end
    end

    context 'with client middleware credentials' do
      let(:chef_run) {
        chef_run = ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3')
        chef_run.node.set['mcollective']['connector'] = 'rabbitmq'
        chef_run.node.set['mcollective']['stomp']['username'] = 'testuser'
        chef_run.node.set['mcollective']['stomp']['password'] = 'testpass'
        chef_run.node.set['mcollective']['stomp']['client_username'] = 'clientuser'
        chef_run.node.set['mcollective']['stomp']['client_password'] = 'clientpass'
        chef_run.converge(described_recipe)
      }

      it 'writes the activemq credentials in the client config' do
        words = %w{clientuser clientpass}
        words.each do |word|
          expect(chef_run).to render_file('/etc/mcollective/client.cfg')
            .with_content(/plugin.rabbitmq.*#{word}/)
        end
      end
    end
  end

  context 'configured to use redis' do
    let(:chef_run) {
      chef_run = ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3')
      chef_run.node.set['mcollective']['connector'] = 'redis'
      chef_run.converge(described_recipe)
    }

    it 'sets the connector in client.cfg' do
      expect(chef_run).to render_file('/etc/mcollective/client.cfg')
        .with_content(/connector = redis/)
    end
  end
end
