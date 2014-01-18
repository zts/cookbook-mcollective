require 'spec_helper'

describe 'mcollective::client' do
  let(:chef_run) { ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3').converge(described_recipe) }

  it 'installs mcollective' do
    expect(chef_run).to install_package('mcollective-client')
  end

  it 'writes /etc/mcollective/client.cfg' do
    expect(chef_run).to render_file('/etc/mcollective/client.cfg')
  end

  context 'configured to use activemq' do
    let(:chef_run) {
      chef_run = ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3')
      chef_run.node.set['mcollective']['connector'] = 'activemq'
      chef_run.converge(described_recipe)
    }

    it 'sets the connector in client.cfg' do
      expect(chef_run).to render_file('/etc/mcollective/client.cfg')
        .with_content(/connector = activemq/)
    end
  end

  context 'configured to use rabbitmq' do
    let(:chef_run) {
      chef_run = ChefSpec::Runner.new(:platform => 'redhat', :version => '6.3')
      chef_run.node.set['mcollective']['connector'] = 'rabbitmq'
      chef_run.converge(described_recipe)
    }

    it 'sets the connector in client.cfg' do
      expect(chef_run).to render_file('/etc/mcollective/client.cfg')
        .with_content(/connector = rabbitmq/)
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
