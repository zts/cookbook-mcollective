module MCollective
  module Agent
    # An agent to manage the Chef Client Daemon
    #
    # Based on a Chef agent by Nicolas Szalay, which in turn
    # credits the original Puppet agent by R.I. Pienaar.
    #
    class Chef<RPC::Agent
      metadata      :name => "Chef Client Agent",
      :description        => "Manage the chef-client daemon",
      :author             => "Zachary Stevens <zts@cryptocracy.com>",
      :license            => "Apache License 2.0",
      :version            => "1.0",
      :url                => "http://github.com/zts/chef-cookbook-mcollective",
      :timeout            => 60

      def startup_hook
        @initscript = @config.pluginconf["chef.client-initscript"] || "/etc/init.d/chef-client"
        @pidfile = @config.pluginconf["chef.client-pidfile"] || "/var/run/chef/client.pid"
      end

      action "wake_daemon" do
        if File.exists?(@pidfile) then
          pid = File.read(@pidfile).to_i
        else
          reply.fail! "chef-client pidfile not found."
        end

        begin
          Process.kill("USR1", pid)
          reply.statusmsg = "Waking up chef-client daemon..."
        rescue Errno::ESRCH
          reply.fail "chef-client pidfile found, but stale - no process to signal."
        end
      end

      action "status" do
        out = ""
        err = ""
        exitcode = run("#{@initscript} status", :stdout => out, :stderr => err)
        if exitcode == 0 then
          reply.statusmsg = "chef-client daemon is running"
        else
          reply.fail! "chef-client daemon is NOT running"
        end
      end

      %w{start stop restart}.each do |act|
        action act do
          Log.debug("=> running #{@initscript} #{act}")
          reply[:stdout] = ""
          reply[:stderr] = ""
          reply[:exitcode] = run("#{@initscript} #{act}", :stdout => reply[:stdout], :stderr => reply[:stderr])
          reply.fail "#{@initscript} finished with exit code #{reply[:exitcode]}" if reply[:exitcode] != 0
        end
      end
    end # end of class Chef
  end
end
