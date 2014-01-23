require 'spec_helper'

describe file('/etc/mcollective/site_plugins/mcollective') do
  it {
    should be_directory
    should be_mode '755'
  }
end
