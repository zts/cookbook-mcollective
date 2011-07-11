maintainer       "Zachary Stevens"
maintainer_email "zts@cryptocracy.com"
license          "All rights reserved"
description      "Installs/Configures mcollective"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

depends "apt"
#depends "yum"

recipe "mcollective::default", "Installs and configures mcollective client+server"
