# == Class carbon::params
#
#
class carbon::params {
  $gr_carbon_ver   = '0.9.15'
  $gr_carbon_pkg   = 'python-carbon'
  $gr_twisted_ver  = '12.2.0'
  $gr_twisted_pkg  = 'python-twisted-core'
  $gr_whisper_ver  = '0.9.15'
  $gr_whisper_pkg  = 'python-whisper'
  $manage_packages = true
}
