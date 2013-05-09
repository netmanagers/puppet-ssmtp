# Puppet module: ssmtp

This is a Puppet module for ssmtp based on the second generation layout ("NextGen") of Example42 Puppet Modules.

Made by Javier Bertoli / Netmanagers

Official site: http://www.netmanagers.com.ar

Official git repository: http://github.com/netmanagers/puppet-ssmtp

Released under the terms of Apache 2 License.

This module depends on R.I.Pienaar's concat module (https://github.com/ripienaar/puppet-concat).

This module requires functions provided by the Example42 Puppi module (you need it even if you don't use and install Puppi)

## USAGE - Basic management

* All parameters can be set using Hiera. See the manifests to see what can be set.

* Install ssmtp with default distro's settings

        class { 'ssmtp': }

* You can install and configure overriding default parameters, using a template
  (ie., the included one):

        class { 'ssmtp': 
          template         => 'ssmtp/ssmtp.conf.erb',
          root_destination => 'postmaster',
          mailhub          => 'my.shiny.mail.server',
        }

* Install a specific version of ssmtp package

        class { 'ssmtp':
          version => '1.0.1',
        }

* Remove ssmtp resources

        class { 'ssmtp':
          absent => true
        }

* Enable auditing without without making changes on existing ssmtp configuration *files*

        class { 'ssmtp':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'ssmtp':
          noops => true
        }

* If you want to add revaliases, you can use ssmtp::revalias.
  See man ssmtp(8) and the define for more details:

        ssmtp::revalias { 'postmaster':
          from    => 'javier@netmanagers.com.ar',
          mailhub => 'my.other.mailhub',
        }

## USAGE - Overrides and Customizations
* Use custom sources for main config file 

        class { 'ssmtp':
          source => [ "puppet:///modules/netmanagers/ssmtp/ssmtp.conf-${hostname}" , "puppet:///modules/netmanagers/ssmtp/ssmtp.conf" ], 
        }


* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'ssmtp':
          template => 'netmanagers/ssmtp/ssmtp.conf.erb',
        }

* Automatically include a custom subclass

        class { 'ssmtp':
          my_class => 'netmanagers::my_ssmtp',
        }



[![Build Status](https://travis-ci.org/netmanagers/puppet-ssmtp.png?branch=master)](https://travis-ci.org/netmanagers/puppet-ssmtp)
