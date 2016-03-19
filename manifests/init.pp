# == Class: carbon
#
# Full description of class carbon here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'carbon':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class carbon (
  $gr_amqp_exchange                      = $carbon::params::gr_amqp_exchange,
  $gr_amqp_host                          = $carbon::params::gr_amqp_host,
  $gr_amqp_metric_name_in_body           = $carbon::params::gr_amqp_metric_name_in_body,
  $gr_amqp_port                          = $carbon::params::gr_amqp_port,
  $gr_amqp_verbose                       = $carbon::params::gr_amqp_verbose,
  $gr_amqp_user                          = $carbon::params::gr_amqp_user,
  $gr_amqp_vhost                         = $carbon::params::gr_amqp_vhost,
  $gr_cache_query_backlog                = $carbon::params::gr_cache_query_backlog,
  $gr_cache_query_interface              = $carbon::params::gr_cache_query_interface,
  $gr_cache_query_port                   = $carbon::params::gr_cache_query_port,
  $gr_cache_write_strategy               = $carbon::params::gr_cache_write_strategy,
  $gr_carbon_metric_interval             = $carbon::params::gr_carbon_metric_interval,
  $gr_carbon_metric_prefix               = $carbon::params::gr_carbon_metric_prefix,
  $gr_carbon_ver                         = $carbon::params::gr_carbon_ver,
  $gr_carbon_pkg                         = $carbon::params::gr_carbon_pkg,
  $gr_conf_dir                           = $carbon::params::gr_conf_dir,
  $gr_enable_amqp                        = $carbon::params::gr_enable_amqp,
  $gr_enable_logrotation                 = $carbon::params::gr_enable_logrotation,
  $gr_enable_udp_listener                = $carbon::params::gr_enable_udp_listener,
  $gr_line_receiver_backlog              = $carbon::params::gr_line_receiver_backlog,
  $gr_line_receiver_interface            = $carbon::params::gr_line_receiver_interface,
  $gr_line_receiver_port                 = $carbon::params::gr_line_receiver_port,
  $gr_local_data_dir                     = $carbon::params::gr_local_data_dir,
  $gr_log_cache_hits                     = $carbon::params::gr_log_cache_hits,
  $gr_log_cache_queue_sorts              = $carbon::params::gr_log_cache_queue_sorts,
  $gr_log_dir                            = $carbon::params::gr_log_dir,
  $gr_log_listener_connections           = $carbon::params::gr_log_listener_connections,
  $gr_log_updates                        = $carbon::params::gr_log_updates,
  $gr_max_cache_size                     = $carbon::params::gr_max_cache_size,
  $gr_max_creates_per_minute             = $carbon::params::gr_max_creates_per_minute,
  $gr_max_updates_per_second             = $carbon::params::gr_max_updates_per_second,
  $gr_max_updates_per_second_on_shutdown = $carbon::params::gr_max_updates_per_second_on_shutdown,
  $gr_pickle_receiver_backlog            = $carbon::params::gr_pickle_receiver_backlog,
  $gr_pickle_receiver_interface          = $carbon::params::gr_pickle_receiver_interface,
  $gr_pickle_receiver_port               = $carbon::params::gr_pickle_receiver_port,
  $gr_pid_dir                            = $carbon::params::gr_pid_dir,
  $gr_storage_dir                        = $carbon::params::gr_storage_dir,
  $gr_storage_schemas                    = $carbon::params::gr_storage_schemas,
  $gr_twisted_ver                        = $carbon::params::gr_twisted_ver,
  $gr_twisted_pkg                        = $carbon::params::gr_twisted_pkg,
  $gr_udp_receiver_interface             = $carbon::params::gr_udp_receiver_interface,
  $gr_udp_receiver_port                  = $carbon::params::gr_udp_receiver_port,
  $gr_use_flow_control                   = $carbon::params::gr_use_flow_control,
  $gr_use_insecure_unpickler             = $carbon::params::gr_use_insecure_unpickler,
  $gr_use_whitelist                      = $carbon::params::gr_use_whitelist,
  $gr_user                               = $carbon::params::gr_user,
  $gr_whisper_autoflush                  = $carbon::params::gr_whisper_autoflush,
  $gr_whisper_fallocate_create           = $carbon::params::gr_whisper_fallocate_create,
  $gr_whisper_lock_writes                = $carbon::params::gr_whisper_lock_writes,
  $gr_whisper_sparse_create              = $carbon::params::gr_whisper_sparse_create,
  $gr_whisper_ver                        = $carbon::params::gr_whisper_ver,
  $gr_whisper_pkg                        = $carbon::params::gr_whisper_pkg,
  $gr_whitelists_dir                     = $carbon::params::gr_whitelists_dir,
  $manage_packages                       = $carbon::params::manage_packages,
) inherits carbon::params {

  validate_absolute_path( $gr_conf_dir )
  validate_absolute_path( $gr_local_data_dir )
  validate_absolute_path( $gr_log_dir )
  validate_absolute_path( $gr_pid_dir )
  validate_absolute_path( $gr_storage_dir )
  validate_absolute_path( $gr_whitelists_dir )
 
  validate_bool (
    $manage_packages
  )

  validate_re( $gr_amqp_metric_name_in_body, 'False|True' )
  validate_re( $gr_amqp_verbose, 'False|True' )
  validate_re( $gr_carbon_ver, '^\d+\.\d+\.\d+' )
  validate_re( $gr_enable_amqp, 'False|True' )
  validate_re( $gr_enable_logrotation, 'False|True' )
  validate_re( $gr_enable_udp_listener, 'False|True' )
  validate_re( $gr_log_cache_hits, 'False|True' )
  validate_re( $gr_log_cache_queue_sorts, 'False|True' )
  validate_re( $gr_log_listener_connections, 'False|True' )
  validate_re( $gr_log_updates, 'False|True' )
  validate_re( $gr_twisted_ver, '^\d+\.\d+\.\d+' )
  validate_re( $gr_use_flow_control, 'False|True' )
  validate_re( $gr_use_insecure_unpickler, 'False|True' )
  validate_re( $gr_whisper_autoflush, 'False|True' )
  validate_re( $gr_whisper_fallocate_create, 'False|True' )
  validate_re( $gr_whisper_ver, '^\d+\.\d+\.\d+' )

  validate_string(
    $gr_amqp_exchange,
    $gr_amqp_host,
    $gr_amqp_user,
    $gr_cache_write_strategy,
    $gr_carbon_metric_prefix,
    $gr_carbon_pkg,
    $gr_twisted_pkg,
    $gr_user,
    $gr_whisper_pkg
  )

  anchor { 'carbon::begin': } ->
  class { 'carbon::install': } ->
  class { 'carbon::config': } ~>
  class { 'carbon::service': } ->
  anchor { 'carbon::end': }
}

