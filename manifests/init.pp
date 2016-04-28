# Class: shinken
# ===========================
#
# Install & configure shinken-daemons.
#
# Parameters
# ----------
#
# * `daemons`
# Hash to specify one or more shinken-daemons.
# Default: empty
#
# * `daemons_default`
# Hash to specify default parameters for shinken-daemons.
# Default: empty
#
# Examples
# --------
#
# @example
#class { 'shinken':
#  daemons         => {
#    'broker'      => {},
#    'poller'      => {},
#    'reactionner' => {},
#    'receiver'    => {},
#    'scheduler'   => {
#      'port'          => '7768',
#      'use_local_log' => '0',
#    },
#  },
#  daemons_default => {
#    'user'  => 'shinken',
#    'group' => 'shinken',
#  },
#}
#
# Authors
# -------
#
# Julien Georges <julien.geo@gmail.com>
#
# Copyright
# ---------
#
# Copyright 2016 Julien Georges
#
class shinken (
  $daemons         = {},
  $daemons_default = {},
) inherits shinken::params {

  validate_hash($daemons)
  validate_hash($daemons_default)
  create_resources(shinken::daemon, $daemons, $daemons_default)

}
