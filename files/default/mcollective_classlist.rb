module MCollective
  class ClassList < Chef::Handler

    def report
      state = File.open("/var/tmp/chefnode.txt", "w")

      run_status.node.run_state[:seen_recipes].keys.each do |recipe|
        state.puts("recipe.#{recipe}")
      end
      run_status.node.run_list.roles.each do |role|
        state.puts("role.#{role}")
      end

      state.close
    end
  end
end

