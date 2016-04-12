# == Class carbon::service
#
#
class carbon::service (
  $carbon_caches       = $carbon::carbon_caches,
  $ensure_carbon_cache = $carbon::ensure_carbon_cache,
  $enable_carbon_cache = $carbon::enable_carbon_cache,
) {

  if empty( $carbon_caches ) {
    ### there's only one carbon cache instance
    service { 'carbon-cache':
      ensure => $ensure_carbon_cache,
      enable => $enable_carbon_cache
    }
  } else {
    ### there's more of them.
    carbon::service::instance { keys( $carbon_caches ):
      ensure => $ensure_carbon_cache,
      enable => $enable_carbon_cache,
    }
  }

}
