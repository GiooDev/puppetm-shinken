# Configure default parameters
class shinken::params {
  # set OS specific values
  case $::osfamily {
    'RedHat': {
      $user  = 'nagios'
      $group = 'nagios'
    }

    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
