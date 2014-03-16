module MCollective
  class ClassList < Chef::Handler

    def report
      generate_classlist
      generate_facts
    end

    private
    def generate_classlist
      if Chef::VERSION >= "11.0.0"
      then
        seen_recipes = run_context.loaded_recipes
      else
        seen_recipes = run_status.node.run_state[:seen_recipes].keys
      end

      state = File.open(run_status.node['mcollective']['classesfile'], "w")

      seen_recipes.each do |recipe|
        # Normalise name of default recipes
        name = recipe.match('::') ? recipe : "#{recipe}::default"
        state.puts("recipe.#{name}")
      end
      run_status.node.run_list.roles.each do |role|
        state.puts("role.#{role}")
      end

      state.close
    end
    
    private
    def generate_facts
      result = { "chef_environment" => run_status.node.chef_environment }

      # Add Ohai facts from the whitelist
      facts = run_status.node.automatic_attrs
      whitelist = run_status.node['mcollective']['fact_whitelist']
      whitelist.each do |k|
        ohai_flatten(k, facts[k], [], result)
      end
      # Note Ohai facts we skipped
      blocked = facts.keys - whitelist
      blocked.each do |f|
        result["blocked.#{f}"] = true
      end

      # Write out the facts
      factfilename = run_status.node['mcollective']['yaml_factfile']
      tmp_factfilename = factfilename + ".new"
      factfile = File.open(tmp_factfilename, "w", 0444)
      factfile.write(YAML.dump(result))
      factfile.close
      File.rename(tmp_factfilename, factfilename)
    end
    
    # From https://raw.github.com/puppetlabs/mcollective-plugins/master/facts/ohai/opscodeohai_facts.rb
    private
    # Flattens the Ohai structure into something like:
    #
    #  "languages.java.version"=>"1.6.0"
    def ohai_flatten(key, val, keys, result)
      keys << key
      if val.is_a?(Mash)
        val.each_pair do |nkey, nval|
          ohai_flatten(nkey, nval, keys, result)

          keys.delete_at(keys.size - 1)
        end
      else
        key = keys.join(".")
        if val.is_a?(Array)
          result[key] = val.join(", ")
        else
          result[key] = val
        end
      end
    end

  end
end

