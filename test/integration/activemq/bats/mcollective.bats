@test "server can be discovered by mcollective" {
      run mco find -I `hostname`
      [ $status -eq 0 ]
      [ $(echo "$output" | grep -c `hostname`) -eq 1 ]
}

@test "server responds to mcollective ping" {
      run mco ping -I `hostname`
      [ $status -eq 0 ]
}

@test "server has the mcollective chef agent installed " {
      run mco rpc rpcutil agent_inventory -I `hostname` -j
      agents=$(echo $output | jq -r '.[0].data.agents[].agent')
      [ $(echo "$agents" | grep -c '^chef$') -eq 1 ]
}
