maintainer       "Zachary Stevens"
maintainer_email "zts@cryptocracy.com"
license          "Apache v2.0"
name             "mcollective"
description      "Provides the MCollective orchestration framework."
version          "0.15.1"

%w{ debian ubuntu redhat centos amazon fedora scientific}.each do |os|
  supports os
end

depends "chef_handler", ">= 1.0.4"
depends "apt"
depends "yum"

recipe "mcollective::default", "Installs both client and server."

recipe "mcollective::server", "Installs and configures mcollective server."
recipe "mcollective::client", "Installs and configures mcollective client tools."
