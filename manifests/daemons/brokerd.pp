# Install & configure shinken-broker
class shinken::daemons::brokerd (
  $daemons_dir = $shinken::daemons_dir,
  $workdir     = $shinken::workdir,
  $logdir      = $shinken::logdir,
  $modules_dir = $shinken::modules_dir,
) inherits shinken {
  package { 'shinken-broker':
    ensure => present;
  }

  file { "${daemons_dir}/brokerd.ini":
    ensure  => file,
    content => template('shinken/daemons/brokerd.ini.erb'),
    require => Package['shinken-broker'],
    notify  => Service['shinken-broker'];
  }

  ini_setting { 'set daemons_dir for shinken-broker.service':
    ensure  => present,
    path    => '/usr/lib/systemd/system/shinken-broker.service',
    section => 'Service',
    setting => 'ExecStart',
    value   => "/usr/sbin/shinken-broker -d -c ${daemons_dir}/brokerd.ini",
    require => Package['shinken-broker'],
    notify  => Service['shinken-broker'];
  }

  service { 'shinken-broker':
    ensure => running,
    enable => true;
  }
}
