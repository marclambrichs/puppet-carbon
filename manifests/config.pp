# == Class carbon::config
#
#
class carbon::config (
  $amqp_exchange                      = $carbon::amqp_exchange,
  $amqp_host                          = $carbon::amqp_host,
  $amqp_metric_name_in_body           = $carbon::amqp_metric_name_in_body,
  $amqp_password                      = $carbon::amqp_password,
  $amqp_port                          = $carbon::amqp_port,
  $amqp_user                          = $carbon::amqp_user,
  $amqp_verbose                       = $carbon::amqp_verbose,
  $amqp_vhost                         = $carbon::amqp_vhost,
  $bind_patterns                      = $carbon::bind_patterns,
  $cache_query_backlog                = $carbon::cache_query_backlog,
  $cache_query_interface              = $carbon::cache_query_interface,
  $cache_query_port                   = $carbon::cache_query_port,
  $cache_service_template             = $carbon::cache_service_template,
  $cache_template                     = $carbon::cache_template,
  $cache_write_strategy               = $carbon::cache_write_strategy,
  $carbon_caches                      = $carbon::carbon_caches,
  $carbon_metric_interval             = $carbon::carbon_metric_interval,
  $carbon_metric_prefix               = $carbon::carbon_metric_prefix,
  $config_dir                         = $carbon::config_dir,
  $config_file                        = $carbon::config_file,
  $config_filename                    = $carbon::config_filename,
  $enable_amqp                        = $carbon::enable_amqp,
  $enable_carbon_cache                = $carbon::enable_carbon_cache,
  $enable_logrotation                 = $carbon::enable_logrotation,
  $enable_manhole                     = $carbon::enable_manhole,
  $enable_udp_listener                = $carbon::enable_udp_listener,
  $group                              = $carbon::group,
  $line_receiver_backlog              = $carbon::line_receiver_backlog,
  $line_receiver_interface            = $carbon::line_receiver_interface,
  $line_receiver_port                 = $carbon::line_receiver_port,
  $local_data_dir                     = $carbon::local_data_dir,
  $log_cache_hits                     = $carbon::log_cache_hits,
  $log_cache_queue_sorts              = $carbon::log_cache_queue_sorts,
  $log_dir                            = $carbon::log_dir,
  $log_listener_connections           = $carbon::log_listener_connections,
  $log_updates                        = $carbon::log_updates,
  $manhole_interface                  = $carbon::manhole_interface,
  $manhole_port                       = $carbon::manhole_port,
  $manhole_public_key                 = $carbon::manhole_public_key,
  $manhole_user                       = $carbon::manhole_user,
  $max_cache_size                     = $carbon::max_cache_size,
  $max_creates_per_minute             = $carbon::max_creates_per_minute,
  $max_updates_per_second             = $carbon::max_updates_per_second,
  $max_updates_per_second_on_shutdown = $carbon::max_updates_per_second_on_shutdown,
  $pickle_receiver_backlog            = $carbon::pickle_receiver_backlog,
  $pickle_receiver_interface          = $carbon::pickle_receiver_interface,
  $pickle_receiver_port               = $carbon::pickle_receiver_port,
  $pid_dir                            = $carbon::pid_dir,
  $storage_dir                        = $carbon::storage_dir,
  $storage_aggregations               = $carbon::storage_aggregations,
  $storage_schemas                    = $carbon::storage_schemas,
  $systemd_dir                        = $carbon::systemd_dir,
  $udp_receiver_interface             = $carbon::udp_receiver_interface,
  $udp_receiver_port                  = $carbon::udp_receiver_port,
  $use_flow_control                   = $carbon::use_flow_control,
  $use_insecure_unpickler             = $carbon::use_insecure_unpickler,
  $use_whitelist                      = $carbon::use_whitelist,
  $user                               = $carbon::user,
  $whisper_autoflush                  = $carbon::whisper_autoflush,
  $whisper_fallocate_create           = $carbon::whisper_fallocate_create,
  $whisper_lock_writes                = $carbon::whisper_lock_writes,
  $whisper_sparse_create              = $carbon::whisper_sparse_create,
  $whitelists_dir                     = $carbon::whitelists_dir,
){
  ### create config directory
  file {
    $config_dir:
      ensure => directory,
      group  => $group,
      mode   => '0755',
      owner  => $user,
  }

  ### create data directory
  file {
    $local_data_dir:
      ensure => directory,
      group  => $group,
      mode   => '0755',
      owner  => $user,
  }

  ### create storage-schemas.conf
  file {
    "${config_dir}/storage-schemas.conf":
      ensure  => file,
      content => template("carbon${config_dir}/storage-schemas.conf.erb"),
      group   => $group,
      mode    => '0644',
      owner   => $user,
      require => File[$config_dir],
  }

  ### create storage-aggregation.conf
  file {
    "${config_dir}/storage-aggregation.conf":
      ensure  => file,
      content => template("carbon${config_dir}/storage-aggregation.conf.erb"),
      group   => $group,
      mode    => '0644',
      owner   => $user,
      require => File[$config_dir],
  }

  if $enable_carbon_cache {

    ### create carbon.conf file
    concat { $config_file:
      ensure => present,
      group  => $group,
      mode   => '0644',
      owner  => $user,
#      notify => Service[$carbon_c_relay::service_name]
    }
  
    ### create header in carbon.conf
    concat::fragment { $config_filename:
      target  => $config_file,
      order   => '10',
      content => file("carbon${config_dir}/carbon.conf"),
      require => File[$config_dir],
    }

    $cache_defaults = {
      amqp_exchange                      => $amqp_exchange,
      amqp_host                          => $amqp_host,
      amqp_metric_name_in_body           => $amqp_metric_name_in_body,
      amqp_password                      => $amqp_password,
      amqp_port                          => $amqp_port,
      amqp_user                          => $amqp_user,
      amqp_verbose                       => $amqp_verbose,
      amqp_vhost                         => $amqp_vhost,
      bind_patterns                      => $bind_patterns,
      cache_query_backlog                => $cache_query_backlog,
      cache_query_interface              => $cache_query_interface,
      cache_query_port                   => $cache_query_port,
      cache_template                     => $cache_template,
      cache_write_strategy               => $cache_write_strategy,
      carbon_metric_interval             => $carbon_metric_interval,
      carbon_metric_prefix               => $carbon_metric_prefix,
      config_dir                         => $config_dir,
      config_file                        => $config_file,
      enable_amqp                        => $enable_amqp,
      enable_logrotation                 => $enable_logrotation,
      enable_manhole                     => $enable_manhole,
      enable_udp_listener                => $enable_udp_listener,
      line_receiver_backlog              => $line_receiver_backlog,
      line_receiver_interface            => $line_receiver_interface,
      line_receiver_port                 => $line_receiver_port,
      local_data_dir                     => $local_data_dir,
      log_cache_hits                     => $log_cache_hits,
      log_cache_queue_sorts              => $log_cache_queue_sorts,
      log_dir                            => $log_dir,
      log_listener_connections           => $log_listener_connections,
      log_updates                        => $log_updates,
      manhole_interface                  => $manhole_interface,
      manhole_port                       => $manhole_port,
      manhole_public_key                 => $manhole_public_key,
      manhole_user                       => $manhole_user,
      max_cache_size                     => $max_cache_size,
      max_creates_per_minute             => $max_creates_per_minute,
      max_updates_per_second             => $max_updates_per_second,
      max_updates_per_second_on_shutdown => $max_updates_per_second_on_shutdown,
      pickle_receiver_backlog            => $pickle_receiver_backlog,
      pickle_receiver_interface          => $pickle_receiver_interface,
      pickle_receiver_port               => $pickle_receiver_port,
      pid_dir                            => $pid_dir,
      storage_dir                        => $storage_dir,
      udp_receiver_interface             => $udp_receiver_interface,
      udp_receiver_port                  => $udp_receiver_port,
      use_flow_control                   => $use_flow_control,
      use_insecure_unpickler             => $use_insecure_unpickler,
      use_whitelist                      => $use_whitelist,
      user                               => $user,
      whisper_autoflush                  => $whisper_autoflush,
      whisper_fallocate_create           => $whisper_fallocate_create,
      whisper_lock_writes                => $whisper_lock_writes,
      whisper_sparse_create              => $whisper_sparse_create,
      whitelists_dir                     => $whitelists_dir,
    }

    ### create [cache:x] fragments in carbon.conf
    if empty( $carbon_caches ) {
      create_resources( 'carbon::config::cache', { a => undef }, $cache_defaults )
    } else {
      create_resources( 'carbon::config::cache', $carbon_caches, $cache_defaults )
    }

    ### create systemd files
    if !empty( $carbon_caches ) {
      ### remove existing carbon-cache.service file
      file { "${systemd_dir}/carbon-cache.service":
        ensure => absent,
      }
      ### create service files for all cache instances
      carbon::config::service { keys( $carbon_caches ):
        systemd_dir => $systemd_dir,
        template    => $cache_service_template,
      }
    }
  }
}
