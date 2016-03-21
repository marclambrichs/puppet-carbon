# == Class carbon::service

class carbon::service {

  if $carbon::gr_enable_carbon_cache {
    
    file { '/etc/init.d/carbon-cache':
      ensure  => file,
      content => template("carbon/etc/init.d/${::osfamily}/carbon-cache.erb"),
      mode    => '0750',
      require => Concat[$carbon::config_file]
    }

  }

}
