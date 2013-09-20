# = Class: ssmtp
#
# This is the main ssmtp class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*root_destination*]
#   The user that gets all mail for userids less than 1000. If blank, address
#   rewriting is disabled.
#   Default: postmaster
#
# [*mailhub*]
#   The host to send mail to.
#   Default: mail
#
# [*port*]
#   The port in the [*mailhub*] to connect to.
#   Default: 25
#
# [*rewrite_domain*]
#   The domain from which mail seems to come.
#
# [*hostname*]
#   The full qualified name of the host.  If not specified, the host is queried
#   for its hostname.
#
# [*from_line_override*]
#   Specifies whether the From header of an email, if any, may override the
#   default domain.
#   Default: no
#
# [*use_tls*]
#   Specifies whether ssmtp uses TLS to talk to the SMTP server.
#   Default: no
#
# [*use_starttls*]
#   Specifies whether ssmtp does a EHLO/STARTTLS before starting SSL
#   negotiation. See RFC 2487.
#
# [*tls_cert*]
#   The file name of an RSA certificate to use for TLS, if required.
#
# [*auth_user*]
#   The user name to use for SMTP AUTH. The default is blank, in which case
#   SMTP AUTH is not used.
#
# [*auth_pass*]
#   The password to use for SMTP AUTH.
#
# [*auth_method*]
#   The authorization method to use. If unset, plain text is used.
#   May also be set to “cram-md5”.
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, ssmtp class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $ssmtp_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, ssmtp main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $ssmtp_source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, ssmtp main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $ssmtp_template
#
# [*revaliases_file*]
#   Sets the path to the revaliases file
#   Default: /etc/ssmtp/revaliases
#
# [*revaliases_template*]
#   Sets the path to the template to use as content for the revaliases file
#   used with ssmtp::revalias
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $ssmtp_options
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $ssmtp_absent
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $ssmtp_audit_only
#   and $audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: undef
#
# Default class params - As defined in ssmtp::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of ssmtp package
#
# [*config_file*]
#   Main configuration file path
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include ssmtp"
# - Call ssmtp as a parametrized class
#
# See README for details.
#
#
class ssmtp (
  $root_destination    = params_lookup( 'root_destination' ),
  $mailhub             = params_lookup( 'mailhub' ),
  $port                = params_lookup( 'port' ),
  $rewrite_domain      = params_lookup( 'rewrite_domain' ),
  $hostname            = params_lookup( 'hostname' ),
  $from_line_override  = params_lookup( 'from_line_override' ),
  $use_tls             = params_lookup( 'use_tls' ),
  $use_starttls        = params_lookup( 'use_starttls' ),
  $tls_cert            = params_lookup( 'tls_cert' ),
  $auth_user           = params_lookup( 'auth_user' ),
  $auth_pass           = params_lookup( 'auth_pass' ),
  $auth_method         = params_lookup( 'auth_method' ),
  $config_file_mode    = params_lookup( 'config_file_mode' ),
  $config_file_owner   = params_lookup( 'config_file_owner' ),
  $config_file_group   = params_lookup( 'config_file_group' ),
  $revaliases_file     = params_lookup( 'revaliases_file' ),
  $revaliases_template = params_lookup( 'revaliases_template' ),
  $my_class            = params_lookup( 'my_class' ),
  $source              = params_lookup( 'source' ),
  $template            = params_lookup( 'template' ),
  $options             = params_lookup( 'options' ),
  $version             = params_lookup( 'version' ),
  $absent              = params_lookup( 'absent' ),
  $audit_only          = params_lookup( 'audit_only' , 'global' ),
  $noops               = params_lookup( 'noops' ),
  $package             = params_lookup( 'package' ),
  $config_file         = params_lookup( 'config_file' )
) inherits ssmtp::params {

  $bool_absent=any2bool($absent)
  $bool_audit_only=any2bool($audit_only)

  ### Definition of some variables used in the module
  $manage_package = $ssmtp::bool_absent ? {
    true  => 'absent',
    false => $ssmtp::version,
  }

  $manage_file = $ssmtp::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  $manage_audit = $ssmtp::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $ssmtp::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_file_source = $ssmtp::source ? {
    ''        => undef,
    default   => $ssmtp::source,
  }

  $manage_file_content = $ssmtp::template ? {
    ''        => undef,
    default   => template($ssmtp::template),
  }

  ### Managed resources
  package { $ssmtp::package:
    ensure  => $ssmtp::manage_package,
    noop    => $ssmtp::noops,
  }

  file { 'ssmtp.conf':
    ensure  => $ssmtp::manage_file,
    path    => $ssmtp::config_file,
    mode    => $ssmtp::config_file_mode,
    owner   => $ssmtp::config_file_owner,
    group   => $ssmtp::config_file_group,
    require => Package[$ssmtp::package],
    source  => $ssmtp::manage_file_source,
    content => $ssmtp::manage_file_content,
    replace => $ssmtp::manage_file_replace,
    audit   => $ssmtp::manage_audit,
    noop    => $ssmtp::noops,
  }

  ### Include custom class if $my_class is set
  if $ssmtp::my_class {
    include $ssmtp::my_class
  }
}
