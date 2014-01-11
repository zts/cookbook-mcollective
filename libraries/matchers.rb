if defined?(ChefSpec)
  def enable_chef_handler(message)
    ChefSpec::Matchers::ResourceMatcher.new(:chef_handler, :enable, message)
  end
end
