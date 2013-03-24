## v0.11.0

* Create /etc/mcollective/plugin.d
* Move Stomp plugin configuration to plugin.d
* Parameterise connector type (default remains 'stomp')

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
