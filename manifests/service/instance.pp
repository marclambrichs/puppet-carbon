#
define carbon::service::instance (){
  service { "carbon-cache-${title}":
    ensure => $carbon::gr_ensure_carbon_cache,
    enable => $carbon::gr_enable_carbon_cache
  }
}
