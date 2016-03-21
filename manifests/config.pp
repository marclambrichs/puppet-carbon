# == Class carbon::config

class carbon::config {

  file {
    "${carbon::gr_config_dir}/storage-schemas.conf":
      ensure  => file,
      content => template("carbon${carbon::gr_config_dir}/storage-schemas.conf.erb"),
      mode    => '0644';
  }

  if $carbon::gr_enable_carbon_cache {

    concat { $carbon::config_file:
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
  #    notify => Service[$carbon_c_relay::service_name]
    }
  
    concat::fragment { 'carbon.conf':
      target  => $carbon::config_file,
      order   => '10',
      content => template("carbon${carbon::gr_config_dir}/carbon.conf.erb")
    }

    if empty( $carbon::cc_carbon_caches ) {
      create_resources( 'carbon::config::cache', { a => undef } )
    } else {
      create_resources( 'carbon::config::cache', $carbon::cc_carbon_caches )
    }

    if !empty( $carbon::cc_carbon_caches ) {
      file { "${carbon::gr_systemd_dir}/carbon-cache.service":
        ensure => absent,
      }

      carbon::config::service { keys( $carbon::cc_carbon_caches ): }
    }
  }
}
