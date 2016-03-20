# == Class carbon::config

class carbon::config {

#  file {
#    '/etc/carbon/storage-schemas.conf':
#      ensure  => file,
#      content => template('carbon/etc/carbon/storage-schemas.conf.erb'),
#      mode    => '0644';
#  }

  $config_file = "${carbon::gr_config_dir}/${carbon::gr_config_file}"

  concat { $config_file:
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
#    notify => Service[$carbon_c_relay::service_name]
  }

  concat::fragment { 'header':
    target  => $config_file,
    order   => '10',
    content => template('carbon/etc/carbon/carbon.conf.erb')
  }

  concat::fragment { '[cache]':
    target  => $carbon_c_relay::config_file,
    content => template('carbon/etc/carbon/carbon.conf/cache.erb'),
    order   => '20',
  }
}
