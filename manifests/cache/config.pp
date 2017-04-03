define carbon::cache::config (
  $cache_query_port,
  $config_file,
  $line_receiver_port,
  $pickle_receiver_port,
  $protobuf_receiver_enabled,
  $protobuf_receiver_port,
  $udp_listener_enabled,
  $udp_receiver_port,
) {

  concat::fragment { $title:
    target  => $config_file,
    content => template('carbon/etc/carbon/carbon.conf.cache.erb'),
    order   => '02'
  }
}

