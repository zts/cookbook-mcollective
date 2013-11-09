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
