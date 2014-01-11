# Install stuff we'll want to use in all of our tests

# jq on mco's json output is better than using grep
remote_file "/usr/bin/jq" do
  source "http://stedolan.github.io/jq/download/linux64/jq"
  mode "0755"
end
