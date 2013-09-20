# Class: ssmtp::params
#
# This class defines default parameters used by the main module class ssmtp
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to ssmtp class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class ssmtp::params {

  $root_destination = 'postmaster'
  $mailhub = 'mail'
  $port = ''
  $rewrite_domain = ''
  $hostname = $::fqdn
  $from_line_override = ''
  $use_tls = ''
  $use_starttls = ''
  $tls_cert = ''
  $auth_user = ''
  $auth_pass = ''
  $auth_method = ''

  $revaliases_file = $::osfamily ? {
    default => '/etc/ssmtp/revaliases',
  }

  $revaliases_template = 'ssmtp/revaliases.erb'

  ### Application related parameters

  $package = $::osfamily ? {
    default  => 'ssmtp',
  }

  $config_file = $::osfamily ? {
    default => '/etc/ssmtp/ssmtp.conf',
  }

  $config_file_mode = $::osfamily ? {
    default => '0640',
  }

  $config_file_owner = $::osfamily ? {
    default => 'root',
  }

  $config_file_group = $::osfamily ? {
    default => 'mail',
  }

  # General Settings
  $my_class = ''
  $source = ''
  $template = 'ssmtp/ssmtp.conf.erb'
  $options = ''
  $version = 'present'
  $absent = false
  $audit_only = false
  $noops = undef
}
