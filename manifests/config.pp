class carbon::config (
  $amqp_exchange                      = $::carbon::amqp_exchange,
  $amqp_host                          = $::carbon::amqp_host,
  $amqp_metric_name_in_body           = $::carbon::amqp_metric_name_in_body,
  $amqp_password                      = $::carbon::amqp_password,
  $amqp_port                          = $::carbon::amqp_port,
  $amqp_user                          = $::carbon::amqp_user,
  $amqp_verbose                       = $::carbon::amqp_verbose,
  $amqp_vhost                         = $::carbon::amqp_vhost,
  $cache_query_interface              = $::carbon::cache_query_interface,
  $cache_query_port                   = $::carbon::cache_query_port,
  $cache_write_strategy               = $::carbon::cache_write_strategy,
  $carbon_aggregator_enabled          = $::carbon::carbon_aggregator_enabled,
  $carbon_cache_enabled               = $::carbon::carbon_cache_enabled,
  $carbon_caches                      = $::carbon::carbon_caches,
  $carbon_metric_interval             = $::carbon::carbon_metric_interval,
  $carbon_metric_prefix               = $::carbon::carbon_metric_prefix,
  $carbon_relay_enabled               = $::carbon::carbon_relay_enabled,
  $config_dir                         = $::carbon::config_dir,
  $config_filename                    = $::carbon::config_filename,
  $database                           = $::carbon::database,
  $destination_protocol               = $::carbon::destination_protocol,
  $enable_amqp                        = $::carbon::enable_amqp,
  $enable_log_rotation                = $::carbon::enable_log_rotation,
  $enable_manhole                     = $::carbon::enable_manhole,
  $udp_listener_enabled               = $::carbon::udp_listener_enabled,
  $line_receiver_interface            = $::carbon::line_receiver_interface,
  $line_receiver_port                 = $::carbon::line_receiver_port,
  $log_cache_hits                     = $::carbon::log_cache_hits,
  $log_cache_queue_sorts              = $::carbon::log_cache_queue_sorts,
  $log_creates                        = $::carbon::log_creates,
  $log_dir                            = $::carbon::log_dir,
  $log_listener_conn_success          = $::carbon::log_listener_conn_success,
  $log_updates                        = $::carbon::log_updates,
  $max_cache_size                     = $::carbon::max_cache_size,
  $max_creates_per_minute             = $::carbon::max_creates_per_minute,
  $max_datapoints_per_message         = $::carbon::max_datapoints_per_message,
  $max_queue_size                     = $::carbon::max_queue_size,
  $max_receiver_connections           = $::carbon::max_receiver_connections,
  $max_updates_per_second             = $::carbon::max_updates_per_second,
  $max_updates_per_second_on_shutdown = $::carbon::max_updates_per_second_on_shutdown,
  $metric_client_idle_timeout         = $::carbon::metric_client_idle_timeout,
  $min_reset_interval                 = $::carbon::min_reset_interval,
  $min_reset_ratio                    = $::carbon::min_reset_ratio,
  $min_reset_stat_flow                = $::carbon::min_reset_stat_flow,
  $min_timestamp_resolution           = $::carbon::min_timestamp_resolution,
  $pickle_receiver_interface          = $::carbon::pickle_receiver_interface,
  $pickle_receiver_port               = $::carbon::pickle_receiver_port,
  $pid_dir                            = $::carbon::pid_dir,
  $protobuf_receiver_enabled          = $::carbon::protobuf_receiver_enabled,
  $relay_method                       = $::carbon::relay_method,
  $relay_user                         = $::carbon::relay_user,
  $replication_factor                 = $::carbon::replication_factor,
  $rules_enabled                      = $::carbon::rules_enabled,
  $protobuf_receiver_interface        = $::carbon::protobuf_receiver_interface,
  $protobuf_receiver_port             = $::carbon::protobuf_receiver_port,
  $queue_low_watermark_pct            = $::carbon::queue_low_watermark_pct,
  $storage_dir                        = $::carbon::storage_dir,
  $time_to_defer_sending              = $::carbon::time_to_defer_sending,
  $udp_receiver_interface             = $::carbon::udp_receiver_interface,
  $udp_receiver_port                  = $::carbon::udp_receiver_port,
  $use_flow_control                   = $::carbon::use_flow_control,
  $use_insecure_unpickler             = $::carbon::use_insecure_unpickler,
  $use_ratio_reset                    = $::carbon::use_ratio_reset,
  $use_whitelist                      = $::carbon::use_whitelist,
  $user                               = $::carbon::user,
  $whisper_autoflush                  = $::carbon::whisper_autoflush,
  $whisper_fadvise_random             = $::carbon::whisper_fadvise_random,
  $whisper_fallocate_create           = $::carbon::whisper_fallocate_create,
  $whisper_lock_writes                = $::carbon::whisper_lock_writes,
  $whisper_sparse_create              = $::carbon::whisper_sparse_create,
) {

  $config_file = "${config_dir}/${config_filename}"  

  concat { $config_file:
    path    => $config_file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }

  if $carbon_cache_enabled {
    concat::fragment { 'carbon config - general':
      target  => $config_file,
      content => template('carbon/etc/carbon/carbon.conf.general.erb'),
      order   => '01'
    }

    $carbon_caches.keys().each |$cache| {
      $values = $carbon_caches[$cache]
      carbon::cache::config { "${cache}":
        cache_query_port          => pick( $values[cache_query_port], $cache_query_port ),
        config_file               => $config_file,
        line_receiver_port        => pick( $values[line_receiver_port], $line_receiver_port ),
        pickle_receiver_port      => pick( $values[pickle_receiver_port], $pickle_receiver_port ),
        protobuf_receiver_enabled => pick( $values[protobuf_receiver_enabled], $protobuf_receiver_enabled ),
        protobuf_receiver_port    => pick( $values[protobuf_receiver_port], $protobuf_receiver_port ),
        udp_listener_enabled      => pick( $values[udp_listener_enabled], $udp_listener_enabled ),
        udp_receiver_port         => pick( $values[udp_receiver_port], $udp_receiver_port ),
      }
    }
  }

  if $carbon_relay_enabled {
    concat::fragment { 'carbon config - relay':
      target  => $config_file,
      content => template('carbon/etc/carbon/carbon.conf.relay.erb'),
      order   => '03'
    }

    file { 'relay-rules.conf':
      path    => "${config_dir}/relay-rules.conf",
      content => template('carbon/etc/carbon/relay-rules.conf.erb'),
      owner   => 'root',
      group   => 'root',
    }
  }

  if $carbon_aggregator_enabled {
    concat::fragment { 'carbon config - aggregator':
      target => $config_file,
      content => template('carbon/etc/carbon/carbon.conf.aggregator.erb'),
      order => '04'
    }
  }
}
