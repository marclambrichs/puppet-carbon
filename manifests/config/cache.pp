#
define carbon::config::cache (
  $cache_name = $title,
  $line_receiver_interface   = '0.0.0.0',
  $line_receiver_port        = 2203,
  $udp_receiver_interface    = '0.0.0.0',
  $udp_receiver_port         = 2203,
  $pickle_receiver_interface = '0.0.0.0',
  $pickle_receiver_port      = 2204,
){

  concat::fragment { $cache_name:
    target  => $carbon::config_file,
    content => template('carbon/etc/carbon/carbon.conf/cache.erb'),
    order   => '20',
  }

}
