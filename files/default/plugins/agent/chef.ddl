metadata    :name        => "Chef-Client Agent",
            :description => "Manage the chef-client daemon",
            :author      => "Zachary Stevens <zts@cryptocracy.com>",
            :license     => "Apache License, Version 2.0",
            :version     => "1.0",
            :url         => "http://github.com/zts/chef-cookbook-mcollective/",
            :timeout     => 60

action "wake_daemon", :description => "Nudge a daemonised chef-client" do
    display :failed
end

action "status", :description => "Check whether the chef-client daemon is running" do
    output :status,
           :description => "Status of the chef-client daemon",
           :display_as => "Status"

    summarize do
        aggregate summary(:status)
    end
    display :failed
end

%w{start stop restart}.each do |act|
    action act, :description => "#{act.capitalize} the chef-client daemon" do
        display :failed

        output :stdout,
            :description => "Standard output from the chef-client init script",
            :display_as => "stdout"

        output :stderr,
            :description => "Error output from the chef-client init script",
            :display_as => "stderr"

        output :exitcode,
            :description => "The exit code set by the chef-client init script after running the action.",
            :display_as => "exitcode"
    end
end
