# == Class carbon::install
#
#
class carbon::install inherits carbon {

  if $::carbon::manage_packages {
    create_resources('package', {
      'carbon'  => {
        ensure => $::carbon::gr_carbon_ver,
        name   => $::carbon::gr_carbon_pkg,
      },
      'twisted' => {
        ensure => $::carbon::gr_twisted_ver,
        name   => $::carbon::gr_twisted_pkg,
      },
      'whisper' => {
        ensure => $::carbon::gr_whisper_ver,
        name   => $::carbon::gr_whisper_pkg,
      },
    }
    )
  }

}
