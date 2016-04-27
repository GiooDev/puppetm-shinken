# Install & configure shinken-poller
class shinken::daemons::pollerd (
  $daemons_dir = $shinken::daemons_dir,
  $workdir     = $shinken::workdir,
  $logdir      = $shinken::logdir,
  $modules_dir = $shinken::modules_dir,
) inherits shinken {
  package { 'shinken-poller':
    ensure => present;
  }

  file { "${daemons_dir}/pollerd.ini":
    ensure  => file,
    content => template('shinken/daemons/pollerd.ini.erb'),
    require => Package['shinken-poller'],
    notify  => Service['shinken-poller'];
  }

  ini_setting { 'set daemons_dir for shinken-poller.service':
    ensure  => present,
    path    => '/usr/lib/systemd/system/shinken-poller.service',
    section => 'Service',
    setting => 'ExecStart',
    value   => "/usr/sbin/shinken-poller -d -c ${daemons_dir}/pollerd.ini",
    require => Package['shinken-poller'],
    notify  => Service['shinken-poller'];
  }

  service { 'shinken-poller':
    ensure => running,
    enable => true;
  }
}
