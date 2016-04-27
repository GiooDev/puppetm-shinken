# Install & configure shinken-arbiter
class shinken::daemons::arbiterd (
  $modules_dir = $shinken::modules_dir,
) inherits shinken {
  package { 'shinken-arbiter':
    ensure => present;
  }

  file { '/etc/shinken/shinken.cfg':
    ensure  => file,
    content => template('shinken/shinken.cfg.erb'),
    require => Package['shinken-arbiter'],
    notify  => Service['shinken-arbiter'];
  }

  service { 'shinken-arbiter':
    ensure => running,
    enable => true;
  }
}
