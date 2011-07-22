#
# Cookbook Name:: mcollective
# Recipe:: default
#
# Copyright 2011, Zachary Stevens
#
# Licensed under the Apache License, Version 2.0 (the "License");
#

include_recipe "mcollective::server"
include_recipe "mcollective::client"
