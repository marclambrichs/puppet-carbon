# == Class carbon::service

class carbon::service {

  if empty( $carbon::cc_carbon_caches ) {
    service { 'carbon-cache':
      ensure => $carbon::gr_ensure_carbon_cache,
      enable => $carbon::gr_enable_carbon_cache
    }
  } else {
    carbon::service::instance { keys( $carbon::cc_carbon_caches ): }
  }

}
