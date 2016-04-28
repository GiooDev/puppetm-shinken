# Create daemons
define shinken::daemon (
  $daemons_dir             = '/etc/shinken/daemons',
  # Path Configuration
  $workdir                 = '/var/run/shinken',
  $logdir                  = '/var/log/shinken',
  $modules_dir             = '/var/lib/shinken/modules',
  # Global configuration
  $user                    = $shinken::params::user,
  $group                   = $shinken::params::group,
  $daemon_enabled          = 1,
  # Network configuration
  $host                    = undef,
  $port                    = undef,
  $idontcareaboutsecurity  = 0,
  # SSL configuration
  $use_ssl                 = 0,
  $hard_ssl_name_check     = 0,
  $http_backend            = 'auto',
  $daemon_thread_pool_size = 16,
  # Local log management
  $use_local_log           = 1,
  $log_level               = 'WARNING',
  # External modules watchdog
  $max_queue_size          = 100000,
) {
  ## Checks
  # The base class must be included first because it is used by parameter defaults
  if ! defined(Class['shinken']) {
    fail('You must include the shinken base class before using any shinken defined resources')
  }
  validate_re($name, ['broker','poller','reactionner','receiver','scheduler'],
  "shinken::daemon ${name} does not match ['broker','poller','reactionner','receiver','scheduler']")

  validate_absolute_path($daemons_dir)
  validate_absolute_path($workdir)
  if $port { validate_integer($port) }
  validate_integer([$daemon_enabled, $idontcareaboutsecurity, $use_ssl, $hard_ssl_name_check, $use_local_log], 1, 0)
  validate_integer($daemon_thread_pool_size)
  validate_re(upcase($log_level), ['DEBUG','INFO','WARNING','ERROR','CRITICAL'])
  validate_integer($max_queue_size)

  ## Execution
  package { "shinken-${name}":
    ensure => present;
  }

  file { "${daemons_dir}/${name}d.ini":
    ensure  => file,
    content => template('shinken/daemon.ini.erb'),
    require => Package["shinken-${name}"],
    notify  => Service["shinken-${name}"];
  }

  ini_setting { "set daemons_dir for shinken-${name}.service":
    ensure  => present,
    path    => "/usr/lib/systemd/system/shinken-${name}.service",
    section => 'Service',
    setting => 'ExecStart',
    value   => "/usr/sbin/shinken-${name} -d -r -c ${daemons_dir}/${name}d.ini",
    require => Package["shinken-${name}"],
    notify  => Service["shinken-${name}"];
  }

  service { "shinken-${name}":
    ensure => running,
    enable => true;
  }
}
