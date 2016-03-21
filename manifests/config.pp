# == Class carbon::config

class carbon::config {

  ### create storage-schemas.conf
  file {
    "${carbon::gr_config_dir}/storage-schemas.conf":
      ensure  => file,
      content => template("carbon${carbon::gr_config_dir}/storage-schemas.conf.erb"),
      group   => $carbon::gr_group,
      mode    => '0644',
      owner   => $carbon::gr_user,
  }

  ### create storage-aggregation.conf
  file {
    "${carbon::gr_config_dir}/storage-aggregation.conf":
      ensure  => file,
      content => template("carbon${carbon::gr_config_dir}/storage-aggregation.conf.erb"),
      group   => $carbon::gr_group,
      mode    => '0644',
      owner   => $carbon::gr_user,
  }

  if $carbon::gr_enable_carbon_cache {

    ### create carbon.conf file
    concat { $carbon::config_file:
      ensure => present,
      group  => $carbon::gr_group,
      mode   => '0644',
      owner  => $carbon::gr_user,
  #    notify => Service[$carbon_c_relay::service_name]
    }
  
    ### create header in carbon.conf
    concat::fragment { 'carbon.conf':
      target  => $carbon::config_file,
      order   => '10',
      content => template("carbon${carbon::gr_config_dir}/carbon.conf.erb")
    }

    ### create [cache:x] fragments in carbon.conf
    if empty( $carbon::cc_carbon_caches ) {
      create_resources( 'carbon::config::cache', { a => undef } )
    } else {
      create_resources( 'carbon::config::cache', $carbon::cc_carbon_caches )
    }

    ### create systemd files
    if !empty( $carbon::cc_carbon_caches ) {
      ### remove existing carbon-cache.service file
      file { "${carbon::gr_systemd_dir}/carbon-cache.service":
        ensure => absent,
      }
      ### create service files for all cache instances
      carbon::config::service { keys( $carbon::cc_carbon_caches ): }
    }
  }
}
