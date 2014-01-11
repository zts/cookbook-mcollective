site :opscode

metadata

group :integration do
  cookbook 'activemq', '~> 1.3.0'
  cookbook 'rabbitmq', github: 'davent/rabbitmq'
  cookbook 'yum', '< 3.0' # rabbitmq is not updated for 3.0 yet
  cookbook 'mcollective_test', path: 'test/fixtures/cookbooks/mcollective_test'
end
