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
  $cc_amqp_exchange                      = $carbon::params::cc_amqp_exchange,
  $cc_amqp_host                          = $carbon::params::cc_amqp_host,
  $cc_amqp_metric_name_in_body           = $carbon::params::cc_amqp_metric_name_in_body,
  $cc_amqp_port                          = $carbon::params::cc_amqp_port,
  $cc_amqp_verbose                       = $carbon::params::cc_amqp_verbose,
  $cc_amqp_user                          = $carbon::params::cc_amqp_user,
  $cc_amqp_vhost                         = $carbon::params::cc_amqp_vhost,
  $cc_cache_query_backlog                = $carbon::params::cc_cache_query_backlog,
  $cc_cache_query_interface              = $carbon::params::cc_cache_query_interface,
  $cc_cache_query_port                   = $carbon::params::cc_cache_query_port,
  $cc_cache_write_strategy               = $carbon::params::cc_cache_write_strategy,
  $cc_carbon_metric_interval             = $carbon::params::cc_carbon_metric_interval,
  $cc_carbon_metric_prefix               = $carbon::params::cc_carbon_metric_prefix,
  $cc_enable_amqp                        = $carbon::params::cc_enable_amqp,
  $cc_enable_logrotation                 = $carbon::params::cc_enable_logrotation,
  $cc_enable_udp_listener                = $carbon::params::cc_enable_udp_listener,
  $cc_line_receiver_backlog              = $carbon::params::cc_line_receiver_backlog,
  $cc_line_receiver_interface            = $carbon::params::cc_line_receiver_interface,
  $cc_line_receiver_port                 = $carbon::params::cc_line_receiver_port,
  $cc_local_data_dir                     = $carbon::params::cc_local_data_dir,
  $cc_log_cache_hits                     = $carbon::params::cc_log_cache_hits,
  $cc_log_cache_queue_sorts              = $carbon::params::cc_log_cache_queue_sorts,
  $cc_log_dir                            = $carbon::params::cc_log_dir,
  $cc_log_listener_connections           = $carbon::params::cc_log_listener_connections,
  $cc_log_updates                        = $carbon::params::cc_log_updates,
  $cc_max_cache_size                     = $carbon::params::cc_max_cache_size,
  $cc_max_creates_per_minute             = $carbon::params::cc_max_creates_per_minute,
  $cc_max_updates_per_second             = $carbon::params::cc_max_updates_per_second,
  $cc_max_updates_per_second_on_shutdown = $carbon::params::cc_max_updates_per_second_on_shutdown,
  $cc_pickle_receiver_backlog            = $carbon::params::cc_pickle_receiver_backlog,
  $cc_pickle_receiver_interface          = $carbon::params::cc_pickle_receiver_interface,
  $cc_pickle_receiver_port               = $carbon::params::cc_pickle_receiver_port,
  $cc_pid_dir                            = $carbon::params::cc_pid_dir,
  $cc_storage_dir                        = $carbon::params::cc_storage_dir,
  $cc_storage_schemas                    = $carbon::params::cc_storage_schemas,
  $cc_udp_receiver_interface             = $carbon::params::cc_udp_receiver_interface,
  $cc_udp_receiver_port                  = $carbon::params::cc_udp_receiver_port,
  $cc_use_flow_control                   = $carbon::params::cc_use_flow_control,
  $cc_use_insecure_unpickler             = $carbon::params::cc_use_insecure_unpickler,
  $cc_use_whitelist                      = $carbon::params::cc_use_whitelist,
  $cc_whisper_autoflush                  = $carbon::params::cc_whisper_autoflush,
  $cc_whisper_fallocate_create           = $carbon::params::cc_whisper_fallocate_create,
  $cc_whisper_lock_writes                = $carbon::params::cc_whisper_lock_writes,
  $cc_whisper_sparse_create              = $carbon::params::cc_whisper_sparse_create,
  $cc_whitelists_dir                     = $carbon::params::cc_whitelists_dir,
  $gr_carbon_ver                         = $carbon::params::gr_carbon_ver,
  $gr_carbon_pkg                         = $carbon::params::gr_carbon_pkg,
  $gr_config_dir                         = $carbon::params::gr_config_dir,
  $gr_config_file                        = $carbon::params::gr_config_file,
  $gr_enable_carbon_cache                = $carbon::params::gr_enable_carbon_cache,
  $gr_enable_carbon_relay                = $carbon::params::gr_enable_carbon_relay,
  $gr_twisted_pkg                        = $carbon::params::gr_twisted_pkg,
  $gr_twisted_ver                        = $carbon::params::gr_twisted_ver,
  $gr_user                               = $carbon::params::gr_user,
  $gr_whisper_pkg                        = $carbon::params::gr_whisper_pkg,
  $gr_whisper_ver                        = $carbon::params::gr_whisper_ver,
  $manage_packages                       = $carbon::params::manage_packages,
) inherits carbon::params {

  $config_file = "${gr_config_dir}${gr_config_file}"

  validate_absolute_path( $gr_config_dir )
  validate_absolute_path( $cc_local_data_dir )
  validate_absolute_path( $cc_log_dir )
  validate_absolute_path( $cc_pid_dir )
  validate_absolute_path( $cc_storage_dir )
  validate_absolute_path( $cc_whitelists_dir )

  validate_bool (
    $gr_enable_carbon_relay,
    $manage_packages
  )

  validate_re( $cc_amqp_metric_name_in_body, 'False|True' )
  validate_re( $cc_amqp_verbose, 'False|True' )
  validate_re( $cc_enable_amqp, 'False|True' )
  validate_re( $cc_enable_logrotation, 'False|True' )
  validate_re( $cc_enable_udp_listener, 'False|True' )
  validate_re( $cc_log_cache_hits, 'False|True' )
  validate_re( $cc_log_cache_queue_sorts, 'False|True' )
  validate_re( $cc_log_listener_connections, 'False|True' )
  validate_re( $cc_log_updates, 'False|True' )
  validate_re( $cc_use_flow_control, 'False|True' )
  validate_re( $cc_use_insecure_unpickler, 'False|True' )
  validate_re( $cc_whisper_autoflush, 'False|True' )
  validate_re( $cc_whisper_fallocate_create, 'False|True' )

  validate_re( $gr_carbon_ver, '^\d+\.\d+\.\d+' )
  validate_re( $gr_twisted_ver, '^\d+\.\d+\.\d+' )
  validate_re( $gr_whisper_ver, '^\d+\.\d+\.\d+' )

  validate_string(
    $cc_amqp_exchange,
    $cc_amqp_host,
    $cc_amqp_user,
    $cc_cache_write_strategy,
    $cc_carbon_metric_prefix,
    $gr_carbon_pkg,
    $gr_config_file,
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
