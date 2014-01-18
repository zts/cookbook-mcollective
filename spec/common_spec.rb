require 'spec_helper'

describe 'mcollective::common' do
  let(:chef_run) { ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3').converge(described_recipe) }

  it "sets the default attributes" do
    expect(chef_run.node['mcollective']['site_plugins']).to be
    expect(chef_run.node['mcollective']['plugin_conf']).to be
    expect(chef_run.node['mcollective']['users']).to respond_to(:each)
  end

  it 'creates the mcollective group' do
    expect(chef_run).to create_group('mcollective')
  end

  it 'creates the activemq config with correct permissions' do
    expect(chef_run).to create_template('/etc/mcollective/plugin.d/activemq.cfg')
      .with(group: 'mcollective', mode: '0640')
  end

  it 'creates the rabbitmq config with correct permissions' do
    expect(chef_run).to create_template('/etc/mcollective/plugin.d/rabbitmq.cfg')
      .with(group: 'mcollective', mode: '0640')
  end

  context 'when the mcollective users attribute is populated' do
    let(:chef_run) {
      chef_run = ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3')
      chef_run.node.set['mcollective']['users'] = ['user1']
      chef_run.converge(described_recipe)
    }

    it 'adds the users to the mcollective group' do
      expect(chef_run).to create_group('mcollective').with(members: ['user1'])
    end
  end

  context 'when configured to use activemq' do
    let(:chef_run) {
      chef_run = ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3')
      chef_run.node.set['mcollective']['connector'] = 'activemq'
      chef_run.node.set['mcollective']['stomp']['hostname'] = 'testhost'
      chef_run.node.set['mcollective']['stomp']['port'] = '12345'
      chef_run.node.set['mcollective']['stomp']['username'] = 'testuser'
      chef_run.node.set['mcollective']['stomp']['password'] = 'testpass'
      chef_run.converge(described_recipe)
    }

    it 'writes the activemq plugin config' do
      words = %w{testhost 12345 testuser testpass}
      words.each do |word|
        expect(chef_run).to render_file('/etc/mcollective/plugin.d/activemq.cfg')
          .with_content(/#{word}/)
      end
    end
  end

  context 'when configured to use rabbitmq' do
    let(:chef_run) {
      chef_run = ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3')
      chef_run.node.set['mcollective']['connector'] = 'rabbitmq'
      chef_run.node.set['mcollective']['stomp']['hostname'] = 'testhost'
      chef_run.node.set['mcollective']['stomp']['port'] = '12345'
      chef_run.node.set['mcollective']['stomp']['username'] = 'testuser'
      chef_run.node.set['mcollective']['stomp']['password'] = 'testpass'
      chef_run.converge(described_recipe)
    }

    it 'writes the rabbitmq plugin config' do
      words = %w{testhost 12345 testuser testpass}
      words.each do |word|
        expect(chef_run).to render_file('/etc/mcollective/plugin.d/rabbitmq.cfg')
          .with_content(/#{word}/)
      end
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

    it 'writes the redis plugin config' do
      words = %w{testhost 12345}
      words.each do |word|
        expect(chef_run).to render_file('/etc/mcollective/plugin.d/redis.cfg')
          .with_content(/#{word}/)
      end
    end

    it 'sets correct permissions on the redis plugin config' do
      expect(chef_run).to create_template('/etc/mcollective/plugin.d/redis.cfg')
        .with(group: 'mcollective', mode: '0640')
    end

    it 'installs the redis connector plugin' do
      expect(chef_run).to create_remote_file("/etc/mcollective/site_plugins/mcollective/connector/redis.rb")
    end

    it 'installs the required gems' do
      expect(chef_run).to install_gem_package("redis")
    end
  end
end
