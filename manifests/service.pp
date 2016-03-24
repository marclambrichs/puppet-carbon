# == Class carbon::service

class carbon::service {

  if empty( $carbon::cc_carbon_caches ) {
    ### there's only one carbon cache instance
    service { 'carbon-cache':
      ensure => $carbon::gr_ensure_carbon_cache,
      enable => $carbon::gr_enable_carbon_cache
    }
  } else {
    ### there's more of them.
    carbon::service::instance { keys( $carbon::cc_carbon_caches ): }
  }

}
