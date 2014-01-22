DESCRIPTION
===========

Installs
[the Marionette Collective](https://puppetlabs.com/mcollective/introduction/)
orchestration framework.

PLATFORMS
==========

This cookbook has been tested on Centos 5.6 and 6.3, and Ubuntu 10.04
and 12.04.  It should work without alteration on all recent Debian,
Ubuntu, Fedora, and RHEL-family distributions


REQUIREMENTS
============

MCollective requires a message broker.  It is most commonly used with
the STOMP protocol and ActiveMQ.  A connector for RabbitMQ is also
included with MCollective.

Refer to the
["Getting Started documentation"](http://docs.puppetlabs.com/mcollective/reference/basic/gettingstarted.html#configuring-stomp)
on the Puppet Labs site for details about the required configuration.

Cookbook Dependencies
---------------------

* apt
* yum
* chef_handler

The `chef_handler` LWRP is used to install a report handler (::server only)

The `apt_repository` and `yum_repository` LWRPs are optionally used to configure
the puppetlabs repository for installing packages.


ATTRIBUTES
==========

Refer to `attributes/default.rb` in the cookbook directory for details
of all available attributes.

 * `node['mcollective']['users']` - Array of usernames to add to the
"mcollective" group.
 * `node['mcollective'][install_chef_handler?]` - Installs a Chef
   handler exposing data about the node to mcollective.
 * `node['mcollective'][install_chef_agent?]` - Installs an
   mcollective agent to control chef-client/chef-solo.  You'll need
   this to be installed on both client and server machines to be
   useful.

Frequently Used Settings
------------------------

You may want to set `mcollective['package']['version']` to ensure
your nodes all use the same version of MCollective.

Set `mcollective['securityprovider']` to choose which security plugin
to use.  If you're using the default ("psk"), you will probably want
to change the shared key by setting `mcollective['psk']`.

You will need to provide connection details for your STOMP service
(used by the "stomp" and "activemq" connectors) in `mcollective['stomp']`


USAGE
=====

Configure the connection details using the `mcollective['stomp']`
attributes - I do this in an environment or role.

Add `recipe[mcollective::server']` to the run_list on nodes that
should run the MCollective daemon, and `recipe[mcollective::client]`
on nodes that should have the client tools.  The default recipe
includes both.

When Chef runs, a handler updates MCollective's "class list" with the
roles and recipes used during the run, and its "fact list" with data
from Ohai.



EXTENSION
=========

MCollective Plugins and Configuration
-------------------------------------

To install and configure additional plugins without changing this
cookbook, install the plugin and DDL to the appropriate subdirectory
of `mcollective['site_plugins']`, and create a plugin configuration
file in the `mcollective['plugin_conf']` directory.

Installation
------------

This cookbook installs the MCollective packages using the repositories
provided by PuppetLabs. If you have a local mirror of the required
packages, setting `node['mcollective']['enable_puppetlabs_repo']` to
false will skip installation of the repositories.

If you have more extensive customisation requirements, you can supply
your own installation recipes using the
`node['mcollective'][recipes']` attributes.


TODO
====

* Updates to common configuration should restart the server (but only if it is configured on the node)
* Tests

LICENSE
=======

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
