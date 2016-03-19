# == Class carbon::params
#
#
class carbon::params {
  $gr_amqp_exchange                      = 'graphite'
  $gr_amqp_host                          = 'localhost'
  $gr_amqp_metric_name_in_body           = 'False'
  $gr_amqp_password                      = 'guest'
  $gr_amqp_port                          = 5672
  $gr_amqp_verbose                       = 'False'
  $gr_amqp_user                          = 'guest'
  $gr_amqp_vhost                         = '/'
  $gr_cache_query_backlog                = undef
  $gr_cache_query_interface              = '0.0.0.0'
  $gr_cache_query_port                   = 7002
  $gr_cache_write_strategy               = 'sorted'
  $gr_carbon_metric_interval             = 60
  $gr_carbon_metric_prefix               = 'carbon'
  $gr_carbon_pkg                         = 'python-carbon'
  $gr_conf_dir                           = '/etc/carbon/'
  $gr_enable_amqp                        = 'False'
  $gr_enable_logrotation                 = 'False'
  $gr_enable_udp_listener                = 'False'
  $gr_enable_relay                       = false
  $gr_line_receiver_backlog              = undef
  $gr_line_receiver_interface            = '0.0.0.0'
  $gr_line_receiver_port                 = 2003
  $gr_local_data_dir                     = '/var/lib/carbon/whisper/'
  $gr_log_cache_hits                     = 'False'
  $gr_log_cache_queue_sorts              = 'True'
  $gr_log_dir                            = '/var/log/carbon/'
  $gr_log_listener_connections           = 'True'
  $gr_log_updates                        = 'False'
  $gr_max_cache_size                     = 'inf'
  $gr_max_creates_per_minute             = 50
  $gr_max_updates_per_second             = 500
  $gr_max_updates_per_second_on_shutdown = undef
  $gr_pickle_receiver_backlog            = undef
  $gr_pickle_receiver_interface          = '0.0.0.0'
  $gr_pickle_receiver_port               = 2004
  $gr_pid_dir                            = '/var/run/'
  $gr_storage_dir                        = '/var/lib/carbon/'
  $gr_storage_schemas                    = [
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
  $gr_twisted_pkg                        = 'python-twisted-core'
  $gr_udp_receiver_interface             = '0.0.0.0'
  $gr_udp_receiver_port                  = 2003
  $gr_use_flow_control                   = 'True'
  $gr_use_insecure_unpickler             = 'False'
  $gr_use_whitelist                      = undef
  $gr_user                               = 'carbon'
  $gr_whitelists_dir                     = '/var/lib/carbon/lists/'
  $gr_whisper_fallocate_create           = 'True'
  $gr_whisper_pkg                        = 'python-whisper'
  $gr_whisper_autoflush                  = 'False'
  $gr_whisper_lock_writes                = undef
  $gr_whisper_sparse_create              = undef
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
