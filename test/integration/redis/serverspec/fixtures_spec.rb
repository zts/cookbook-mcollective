require 'spec_helper'

describe port('6379') do
    it { should be_listening }
end

describe file('/usr/bin/jq') do
  it {
    should be_file
    should be_executable
  }
end
