# == Class carbon::install
#
#
class carbon::install (
  $carbon_pkg      = $carbon::carbon_pkg,
  $carbon_version  = $carbon::carbon_version,
  $group           = $carbon::group,
  $manage_packages = $carbon::manage_packages,
  $twisted_pkg     = $carbon::twisted_pkg,
  $twisted_version = $carbon::twisted_version,
  $user            = $carbon::user,
  $whisper_pkg     = $carbon::whisper_pkg,
  $whisper_version = $carbon::whisper_version,
){

  group { $carbon::group:
    ensure => present
  } ->
  user { $carbon::user:
    ensure => present,
    groups => $carbon::group
  }

  if $manage_packages {
    create_resources('package', {
      'carbon'  => {
        ensure => $carbon_version,
        name   => $carbon_pkg,
      },
      'twisted' => {
        ensure => $twisted_version,
        name   => $twisted_pkg,
      },
      'whisper' => {
        ensure => $whisper_version,
        name   => $whisper_pkg,
      },
    }
    )
  }
}
