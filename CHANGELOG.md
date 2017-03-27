## v0.15.1

Fix deprecation warnings.

## v0.15.0

 * Remove middleware credentials from connector plugin files.
 * Add middleware credentials to server configuration.
 * Add middleware credentials to client configuration.
 * Add `mcollective.stomp.client_username` and
   `mcollective.stomp.client_password` attributes.  When specified,
   these will be used for the client's connection to the middleware -
   when unspecified, the client will use the same credentials as the
   server.
 * Add `mcollective.psk_callertype` attribute to set
   `plugin.psk.callertype` in the mcollective configuration.
 * Remove redundant DDL from Chef agent (thanks, @jorhett)
 * Add `mco chef` application (contributed by @jorhett - thankyou!)

## v0.14.3

 * Add mcollective.install\_chef\_agent? attribute to control whether
   the Chef agent is installed by the cookbook.  You may wish to
   disable this if you've packaged the plugin, or don't want to use
   it.
 * Add mcollective.install\_chef\_handler? attribute to control
   whether the Chef handler is installed by the cookbook.  If you
   disable this but enable the agent, note that some functionality may
   be missing or broken.
 * Improvement: be smarter about restarting the mcollective service
   when configuration and plugins are updated.
 * FIX package installation on ubuntu
 * Improve chef agent 'status' action.  The chef-client service is
   identified as "running", "not running", or "missing".
 * Improve chefspec coverage.

## v0.14.2

 * FIX invalid redis connector configuration

## v0.14.1

 * FIX invalid puppetlabs repo added on amazon linux

## v0.14.0

 * Add ['mcollective']['users'] attribute - these users will be added
 to the 'mcollective' group, allowing them to run mco as themselves.
 * Add ['mcollective']['group'] attribute, to specify the groupname.
 * Restrict read permissions on client.cfg to mcollective users

## v0.13.0

 * Support installing (from github) and configuring the redis
   connector.
 * chefspec and kitchen tests covering server installation and
   configuration of activemq/rabbitmq/redis connectors.

## v0.12.1

 * Add support for the new yum cookbook (version 3.x).  Earlier
   versions remain supported.

## v0.12.0

 * FIX overriding mcollective client identity (thanks to Daniel
   Leyden)
 * Add support for native RabbitMQ connector (thanks to Simon
   Pasquier)

## v0.11.0

* Add support for the ActiveMQ connector and direct-addressing mode.

* New parameterised configuration:
 * mcollective identity
 * collective membership
 * connector plugin
 * log level and logfile location
 * factfile and classfile locations

* New defaults:
 * connector is now 'activemq' (was 'stomp')
 * direct_addressing is enabled (was unsupported)

* Recipes have been refactored so that it is easier to customise the
  install process.

* Foodcritic fixes and updated README

## v0.10.2

* security provider can be set from an attribute (default is
  unchanged)
  
## v0.10.1

* Now works on Chef 11.

## v0.10.0

* add an attribute to specify which version to install (thanks to jschneiderhan)
* FEATURE - include an MCollective agent for controlling the chef-client daemon
* FIX - install packages appropriate to the specific Debian or Ubuntu release
* FIX - add the Puppet Labs "dependencies" yum repo (for rubygems-stomp)


## v0.9.1:

* Updated Puppet Labs yum repo location.


## v0.9.0:

* Start of this Changelog.
