# Install & configure shinken-scheduler
class shinken::daemons::schedulerd (
  $daemons_dir = $shinken::daemons_dir,
  $workdir     = $shinken::workdir,
  $logdir      = $shinken::logdir,
  $port        = 7768,
  $modules_dir = $shinken::modules_dir,
) inherits shinken {
  package { 'shinken-scheduler':
    ensure => present;
  }

  file { "${daemons_dir}/schedulerd.ini":
    ensure  => file,
    content => template('shinken/daemons/schedulerd.ini.erb'),
    require => Package['shinken-scheduler'],
    notify  => Service['shinken-scheduler'];
  }

  ini_setting { 'set daemons_dir for shinken-scheduler.service':
    ensure  => present,
    path    => '/usr/lib/systemd/system/shinken-scheduler.service',
    section => 'Service',
    setting => 'ExecStart',
    value   => "/usr/sbin/shinken-scheduler -d -c ${daemons_dir}/schedulerd.ini",
    require => Package['shinken-scheduler'],
    notify  => Service['shinken-scheduler'];
  }

  service { 'shinken-scheduler':
    ensure => running,
    enable => true;
  }
}
