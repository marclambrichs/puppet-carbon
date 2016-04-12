# == type carbon::service::instance
#
#
define carbon::service::instance (
  $ensure,
  $enable,
){
  service { "carbon-cache-${title}":
    ensure => $ensure,
    enable => $enable,
  }
}
