# == Class carbon::params
#
#
class carbon::params {
  $gr_carbon_pkg   = 'python-carbon'
  $gr_storage_schemas = [
    {
      name       => 'carbon',
      pattern    => '^carbon\.',
      retentions => '60:90d'
    },
    {
      name       => 'default_1min_for_1day',
      pattern    => '.*',
      retentions => '60s:1d'
    }
  ]
  $gr_twisted_pkg  = 'python-twisted-core'
  $gr_whisper_pkg  = 'python-whisper'
  $manage_packages = true

  case $::osfamily {
    'RedHat', 'CentOS': {
      case $::operatingsystemmajrelease {
        /^7$/: {
          $gr_carbon_ver   = '0.9.15-1.el7'
          $gr_twisted_ver  = '12.2.0-4.el7'
          $gr_whisper_ver  = '0.9.15-1.el7'
        }
        default: {
          fail("unsupported RedHat major release: ${::operatingsystemmajrelease}")
        }
      }
    }
    default: {
      fail("unsupported osfamily: ${::osfamily}.")
    }
  }
}
