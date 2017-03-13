# == Class: carbon
#
# Puppet class for graphite carbon
#
# === Parameters
#
# @param amqp_exchange
# @param amqp_host
# @param amqp_metric_name_in_body
# @param amqp_password
# @param amqp_port
# @param amqp_user
# @param amqp_verbose
# @param amqp_vhost
# @param cache_query_interface
# @param cache_query_port
# @param cache_write_strategy
# @param carbon_aggregator_enabled
# @param carbon_cache_enabled
# @param carbon_cache_ensure
# @param carbon_caches
# @param carbon_ensure
# @param carbon_metric_interval
# @param carbon_metric_prefix
# @param carbon_pkg
# @param carbon_relay_enabled
# @param carbon_relay_ensure
# @param config_dir
# @param config_filename
# @param database
# @param destination_protocol
# @param enable_amqp
# @param enable_log_rotation
# @param enable_manhole
# @param group
# @param line_receiver_interface
# @param line_receiver_port
# @param log_cache_hits
# @param log_cache_queue_sorts
# @param log_creates
# @param log_dir
# @param log_listener_conn_success
# @param log_updates
# @param manage_pkg
# @param max_cache_size
# @param max_creates_per_minute
# @param max_datapoints_per_message
# @param max_queue_size
# @param max_receiver_connections
# @param max_updates_per_second
# @param max_updates_per_second_on_shutdown
# @param metric_client_idle_timeout
# @param min_reset_interval
# @param min_reset_ratio
# @param min_reset_stat_flow
# @param min_timestamp_resolution
# @param pickle_receiver_interface
# @param pickle_receiver_port
# @param pid_dir
# @param protobuf_receiver_enabled
# @param protobuf_receiver_interface
# @param protobuf_receiver_port
# @param queue_low_watermark_pct
# @param relay_ensure
# @param relay_method
# @param relay_pkg
# @param relay_rules
# @param relay_user
# @param replication_factor
# @param rules_enabled
# @param storage_dir
# @param time_to_defer_sending
# @param udp_listener_enabled
# @param udp_receiver_interface
# @param udp_receiver_port
# @param use_flow_control
# @param use_insecure_unpickler
# @param use_ratio_reset
# @param use_whitelist
# @param user
# @param whisper_autoflush
# @param whisper_fadvise_random
# @param whisper_fallocate_create
# @param whisper_lock_writes
# @param whisper_sparse_create
#
# === Authors
#
# Marc Lambrichs <marc.lambrichs@gmail.com>
#
# === Copyright
#
# Copyright 2017 Marc Lambrichs, unless otherwise noted.
#
class carbon (
  $amqp_exchange                      = 'graphite',
  $amqp_host                          = 'localhost',
  $amqp_metric_name_in_body           = 'False',
  $amqp_password                      = 'guest',
  $amqp_port                          = 5672,
  $amqp_user                          = 'guest',
  $amqp_verbose                       = 'False',
  $amqp_vhost                         = '/',
  $cache_query_interface              = '0.0.0.0',
  $cache_query_port                   = 7002,
  $cache_write_strategy               = 'sorted',
  $carbon_aggregator_enabled          = false,
  $carbon_cache_enabled               = true,
  $carbon_cache_ensure                = running,
  $carbon_caches                      = {},
  $carbon_ensure                      = present,
  $carbon_metric_interval             = 60,
  $carbon_metric_prefix               = 'carbon',
  $carbon_pkg                         = 'python-carbon',
  $carbon_relay_enabled               = true,
  $carbon_relay_ensure                = running,  
  $config_dir                         = '/etc/carbon',
  $config_filename                    = 'carbon.conf',
  $database                           = 'whisper',
  $destination_protocol               = 'pickle',
  $enable_amqp                        = 'False',
  $enable_log_rotation                = 'True',  
  $enable_manhole                     = 'False',
  $group                              = 'carbon',
  $line_receiver_interface            = '0.0.0.0',
  $line_receiver_port                 = 2003,
  $log_cache_hits                     = 'False',
  $log_cache_queue_sorts              = 'False',
  $log_creates                        = 'False',
  $log_dir                            = '/var/log/carbon',
  $log_listener_conn_success          = 'True',
  $log_updates                        = 'False',
  $manage_pkg                         = true,
  $max_cache_size                     = 'inf',
  $max_creates_per_minute             = 50,
  $max_datapoints_per_message         = 500,
  $max_queue_size                     = 10000,
  $max_receiver_connections           = 'inf',
  $max_updates_per_second             = 500,
  $max_updates_per_second_on_shutdown = 1000,
  $metric_client_idle_timeout         = 'None',
  $min_reset_interval                 = 121,
  $min_reset_ratio                    = '0.9',
  $min_reset_stat_flow                = 1000,
  $min_timestamp_resolution           = 1,
  $pickle_receiver_interface          = '0.0.0.0',
  $pickle_receiver_port               = 2004,
  $pid_dir                            = '/var/run',
  $protobuf_receiver_enabled          = false,
  $protobuf_receiver_interface        = '0.0.0.0',
  $protobuf_receiver_port             = 0,
  $queue_low_watermark_pct            = '0.8',
  $relay_ensure                       = absent,
  $relay_method                       = 'consistent-hashing',
  $relay_pkg                          = undef,
  $relay_rules                        = {},
  $relay_user                         = 'carbon',
  $replication_factor                 = 1,
  $rules_enabled                      = 'False',
  $storage_dir                        = '/var/lib/carbon',
  $time_to_defer_sending              = '0.0001',
  $udp_listener_enabled               = 'False',
  $udp_receiver_interface             = '0.0.0.0',
  $udp_receiver_port                  = 2003,
  $use_flow_control                   = 'True',
  $use_insecure_unpickler             = 'False',
  $use_ratio_reset                    = 'False',
  $use_whitelist                      = 'False',
  $user                               = 'carbon',
  $whisper_autoflush                  = 'False',
  $whisper_fadvise_random             = 'False',
  $whisper_fallocate_create           = 'True',
  $whisper_lock_writes                = 'False',
  $whisper_sparse_create              = 'False',
)  {

  member( ['rules', 'consistent-hashing', 'aggregated-consistent-hashing'], $relay_method )
  member( ['line', 'pickle', 'udp', 'protobuf'], $destination_protocol )

  anchor { 'carbon::begin': }->
  class{'::carbon::install': }->
  class{'::carbon::config': }->
  class{'::carbon::service': }->
  anchor { 'carbon::end': }

}
