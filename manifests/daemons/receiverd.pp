# Install & configure shinken-receiver
class shinken::daemons::receiverd (
  $daemons_dir = $shinken::daemons_dir,
  $workdir     = $shinken::workdir,
  $logdir      = $shinken::logdir,
  $port        = 7773,
  $modules_dir = $shinken::modules_dir,
) inherits shinken {
  package { 'shinken-receiver':
    ensure => present,
  }

  file { "${daemons_dir}/receiverd.ini":
    ensure  => file,
    content => template('shinken/daemons/receiverd.ini.erb'),
    require => Package['shinken-receiver'],
    notify  => Service['shinken-receiver'];
  }

  ini_setting { 'set daemons_dir for shinken-receiver.service':
    ensure  => present,
    path    => '/usr/lib/systemd/system/shinken-receiver.service',
    section => 'Service',
    setting => 'ExecStart',
    value   => "/usr/sbin/shinken-receiver -d -c ${daemons_dir}/receiverd.ini",
    require => Package['shinken-receiver'],
    notify  => Service['shinken-receiver'];
  }

  service { 'shinken-receiver':
    ensure => running,
    enable => true;
  }
}
