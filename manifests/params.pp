# == Class carbon::params
#
#
class carbon::params {

  ### variables for carbon cache
  $cc_amqp_exchange                      = 'graphite'
  $cc_amqp_host                          = 'localhost'
  $cc_amqp_metric_name_in_body           = 'False'
  $cc_amqp_password                      = 'guest'
  $cc_amqp_port                          = 5672
  $cc_amqp_verbose                       = 'False'
  $cc_amqp_user                          = 'guest'
  $cc_amqp_vhost                         = '/'
  $cc_cache_query_backlog                = undef
  $cc_cache_query_interface              = '0.0.0.0'
  $cc_cache_query_port                   = 7002
  $cc_cache_write_strategy               = 'sorted'
  $cc_carbon_caches                      = {}
  $cc_carbon_metric_interval             = 60
  $cc_carbon_metric_prefix               = 'carbon'
  $cc_enable_amqp                        = 'False'
  $cc_enable_logrotation                 = 'False'
  $cc_enable_udp_listener                = 'False'
  $cc_line_receiver_backlog              = undef
  $cc_line_receiver_interface            = '0.0.0.0'
  $cc_line_receiver_port                 = 2003
  $cc_local_data_dir                     = '/var/lib/carbon/whisper/'
  $cc_log_cache_hits                     = 'False'
  $cc_log_cache_queue_sorts              = 'True'
  $cc_log_dir                            = '/var/log/carbon/'
  $cc_log_listener_connections           = 'True'
  $cc_log_updates                        = 'False'
  $cc_max_cache_size                     = 'inf'
  $cc_max_creates_per_minute             = 50
  $cc_max_updates_per_second             = 500
  $cc_max_updates_per_second_on_shutdown = undef
  $cc_pickle_receiver_backlog            = undef
  $cc_pickle_receiver_interface          = '0.0.0.0'
  $cc_pickle_receiver_port               = 2004
  $cc_pid_dir                            = '/var/run/'
  $cc_storage_dir                        = '/var/lib/carbon/'
  $cc_storage_schemas                    = [
    {
      name       => 'carbon',
      pattern    => '^carbon\.',
      retentions => '60:90d'
    },
    {
      name       => 'default_1min_for_1day',
      pattern    => '.*',
      retentions => '60s:1d'
    }
  ]
  $cc_udp_receiver_interface             = '0.0.0.0'
  $cc_udp_receiver_port                  = 2003
  $cc_use_flow_control                   = 'True'
  $cc_use_insecure_unpickler             = 'False'
  $cc_use_whitelist                      = undef
  $cc_whitelists_dir                     = '/var/lib/carbon/lists/'
  $cc_whisper_fallocate_create           = 'True'
  $cc_whisper_autoflush                  = 'False'
  $cc_whisper_lock_writes                = undef
  $cc_whisper_sparse_create              = undef

  ### global variables for cache, relay and aggregator
  $gr_carbon_pkg                         = 'python-carbon'
  $gr_config_dir                         = '/etc/carbon/'
  $gr_config_file                        = 'carbon.conf'
  $gr_enable_carbon_cache                = true
  $gr_enable_carbon_relay                = false
  $gr_twisted_pkg                        = 'python-twisted-core'
  $gr_user                               = 'carbon'
  $gr_whisper_pkg                        = 'python-whisper'
  $manage_packages                       = true

  case $::osfamily {
    'RedHat', 'CentOS': {
      case $::operatingsystemmajrelease {
        /^7$/: {
          $gr_carbon_ver   = '0.9.15-1.el7'
          $gr_twisted_ver  = '12.2.0-4.el7'
          $gr_whisper_ver  = '0.9.15-1.el7'
        }
        default: {
          fail("unsupported RedHat major release: ${::operatingsystemmajrelease}")
        }
      }
    }
    default: {
      fail("unsupported osfamily: ${::osfamily}.")
    }
  }
}
