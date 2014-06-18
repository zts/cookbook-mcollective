class MCollective::Application::Chef<MCollective::Application
  description "Checks the status of and Wakes the Chef to perform a run"
  usage "Usage: mco chef [OPTIONS] [FILTERS] [ACTION]"
  usage "ACTION: is one of status, stop, start, restart, or wake"

  # this is a hook called right after option parsing
  def post_option_parser(configuration)
    # we could test or manipulate input values here
    if ARGV.length >= 1
      configuration[:action] = ARGV.shift                                                                                                                                                                          
    end

    raise "Action must be one of status, stop, start, restart, or wake" unless ["status","stop","start","restart","wake"].include?(configuration[:action])
  end

  # Now we enter main processing
  def main
    if configuration[:action] = "wake"
      action = "wake_daemon"
    else
      action = configuration[:action]
    end

    client = rpcclient("chef")
    printrpc client.send( action, :options => options )

    # Exit using halt and it will pass on the appropriate exit code
    printrpcstats
    halt client.stats
  end
end
