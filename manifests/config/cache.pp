# == Type carbon::config::cache
#
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
  $amqp_exchange,
  $amqp_host,
  $amqp_metric_name_in_body,
  $amqp_password,
  $amqp_port,
  $amqp_user,
  $amqp_verbose,
  $amqp_vhost,
  $bind_patterns,
  $cache_query_backlog,
  $cache_query_interface,
  $cache_query_port,
  $cache_template,
  $cache_write_strategy,
  $carbon_metric_interval,
  $carbon_metric_prefix,
  $config_dir,
  $config_file,
  $enable_amqp,
  $enable_logrotation,
  $enable_manhole,
  $enable_udp_listener,
  $line_receiver_backlog,
  $line_receiver_interface,
  $line_receiver_port,
  $local_data_dir,
  $log_cache_hits,
  $log_cache_queue_sorts,
  $log_dir,
  $log_listener_connections,
  $log_updates,
  $manhole_interface,
  $manhole_port,
  $manhole_public_key,
  $manhole_user,
  $max_cache_size,
  $max_creates_per_minute,
  $max_updates_per_second,
  $max_updates_per_second_on_shutdown,
  $pickle_receiver_backlog,
  $pickle_receiver_interface,
  $pickle_receiver_port,
  $pid_dir,
  $storage_dir,
  $udp_receiver_interface,
  $udp_receiver_port,
  $use_flow_control,
  $use_insecure_unpickler,
  $use_whitelist,
  $user,
  $whisper_autoflush,
  $whisper_fallocate_create,
  $whisper_lock_writes,
  $whisper_sparse_create,
  $whitelists_dir,
){

  concat::fragment { $title:
    target  => $config_file,
    content => template($cache_template),
    order   => '20',
  }

}
