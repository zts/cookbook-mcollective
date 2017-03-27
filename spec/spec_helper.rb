require 'chefspec'
require 'chefspec/berkshelf'
require 'yarjuf'

RSpec.configure do |config|
  # Specify the Chef log_level (default: :warn)
  # config.log_level = :debug

  # Specify the operating platform to mock Ohai data from
  config.platform = 'centos'

  # Specify the operating version to mock Ohai data from
  config.version = '6.4'

  # Use color output for RSpec
  config.color = true

  # Use documentation output formatter
  config.formatter = :documentation
end
