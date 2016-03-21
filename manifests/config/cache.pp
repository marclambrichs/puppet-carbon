# [*line_receiver_interface*]
#   Set the interface for the line (plain text) listener. Setting the interface
#   to 0.0.0.0 listens on all interfaces.
#
# [*line_receiver_port*]
#   Set the port for the line (plain text) listener. Setting the Port can be set
#   to 0 to disable this listener if it is not required.
#
# [*pickle_receiver_interface*]
#   Set the interface and port for the pickle listener. Setting the interface to
#   0.0.0.0 listens on all interfaces.

# [*pickle_receiver_port*]
#   Port can be set to 0 to disable this listener if it is not required.
define carbon::config::cache (
  $cache_name = $title,
  $cache_query_port          = 7002,
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
