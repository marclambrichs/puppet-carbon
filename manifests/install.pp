# == Class graphite::install
#
#
class graphite::install inherits graphite {

  if $::graphite::manage_packages {
    create_resources('package', {
      'carbon'  => {
        ensure => $::graphite::gr_carbon_ver,
        name   => $::graphite::gr_carbon_pkg,
      },
      'twisted' => {
        ensure => $::graphite::gr_twisted_ver,
        name   => $::graphite::gr_twisted_pkg,
      },
      'whisper' => {
        ensure => $::graphite::gr_whisper_ver,
        name   => $::graphite::gr_whisper_pkg,
      },
    }, {
      provider => $::graphite::gr_pkg_provider,
      require  => $::graphite::gr_pkg_require,
    }
    )
  }

}
