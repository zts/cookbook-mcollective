require 'spec_helper'

describe service('activemq') do
    it { should be_running }
end

describe file('/usr/bin/jq') do
  it {
    should be_file
    should be_executable
  }
end
