# Define: ssmtp::revalias
#
# Adds a custom ssmtp alias in /etc/ssmtp/revaliases
#
# A reverse alias gives the From: address placed on a user's outgoing messages
# and (optionally) the mailhub these messages will be sent through.
# Example:
#     root:jdoe@isp.com:mail.isp.com
# Messages root sends will be identified as from jdoe@isp.com and sent
# through mail.isp.com.
#
# Supported arguments:
# $revalias - The name you want to give the revalias.
#             If not set, defaults to == $title
# $from     - The From: you want $revalias will be identified as.
# $mailhub  - The mailhub these messages will be sent through.
#             Default: empty
# $order    - f you want to specify an order in the file. Default to 50
# $enable   - true / false. If false, the rule _IS NOT ADDED_ to the
#             revaliases file
#             Defaults to true

define ssmtp::revalias (
  $revalias  = '',
  $from      = '',
  $mailhub   = '',
  $order     = '',
  $enable    = true ) {

  include ssmtp

  $real_revalias = $revalias ? {
    ''      => $name,
    default => $revalias,
  }

  # If (concat) order is not defined we find out the right one
  $real_order = $order ? {
    ''      => '50',
    default => $order,
  }

  $ensure = bool2ensure($enable)

  if ! defined(Concat[$ssmtp::revaliases_file]) {

    concat { $ssmtp::revaliases_file:
      mode    => $ssmtp::config_file_mode,
      warn    => true,
      owner   => $ssmtp::config_file_owner,
      group   => $ssmtp::config_file_group,
    }
  }
  concat::fragment{ "ssmtp_revaliases_${name}":
    ensure  => $ensure,
    target  => $ssmtp::revaliases_file,
    content => template($ssmtp::revaliases_template),
    order   => $real_order,
  }
}
