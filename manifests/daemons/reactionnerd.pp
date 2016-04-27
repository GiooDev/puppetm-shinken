# Install & configure shinken-reactionner
class shinken::daemons::reactionnerd (
  $daemons_dir = $shinken::daemons_dir,
  $workdir     = $shinken::workdir,
  $logdir      = $shinken::logdir,
  $port        = 7769,
  $modules_dir = $shinken::modules_dir,
) inherits shinken {
  package { 'shinken-reactionner':
    ensure => present;
  }

  file { "${daemons_dir}/reactionnerd.ini":
    ensure  => file,
    content => template('shinken/daemons/reactionnerd.ini.erb'),
    require => Package['shinken-reactionner'],
    notify  => Service['shinken-reactionner'];
  }

  ini_setting { 'set daemons_dir for shinken-reactionner.service':
    ensure  => present,
    path    => '/usr/lib/systemd/system/shinken-reactionner.service',
    section => 'Service',
    setting => 'ExecStart',
    value   => "/usr/sbin/shinken-reactionner -d -c ${daemons_dir}/reactionnerd.ini",
    require => Package['shinken-reactionner'],
    notify  => Service['shinken-reactionner'];
  }

  service { 'shinken-reactionner':
    ensure => running,
    enable => true;
  }
}
