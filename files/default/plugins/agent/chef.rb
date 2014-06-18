module MCollective
  module Agent
    # An agent to manage the Chef Client Daemon
    #
    # Based on a Chef agent by Nicolas Szalay, which in turn
    # credits the original Puppet agent by R.I. Pienaar.
    #
    class Chef<RPC::Agent
      def startup_hook
        @initscript = @config.pluginconf["chef.client-initscript"] || "service chef-client"
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
        case exitcode
        when 0
          reply[:status] = "OK"
        when 1
          reply[:status] = "Missing"
        when 3
          reply[:status] = "Stopped"
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
