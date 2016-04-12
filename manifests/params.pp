# == Class carbon::params
#
#
class carbon::params {

  ### TODO
  $storage_aggregations               = [
    {
      name => 'min',
      pattern => '\.min$',
      xFilesFactor => 0.1,
      aggregationMethod => 'min'
    },
    {
      name => 'max',
      pattern => '\.max$',
      xFilesFactor => 0.1,
      aggregationMethod => 'max'
    },
    {
      name => 'sum',
      pattern => '\.count$',
      xFilesFactor => 0,
      aggregationMethod => 'sum',
    },
    {
      name => 'default_average',
      pattern => '.*',
      xFilesFactor => 0.5,
      aggregationMethod => 'average'
    },
  ]
  $storage_schemas                    = [
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

  ### general
  $carbon_caches                      = {}
  $config_dir                         = '/etc/carbon'
  $enable_carbon_cache                = true
  $group                              = 'carbon'
  $user                               = 'carbon'
  $local_data_dir                     = '/var/lib/carbon/whisper'
  $systemd_dir                        = '/usr/lib/systemd/system'

  ### carbon::service
  $ensure_carbon_cache                = running

  ### carbon::config
  $cache_service_template             = 'carbon-cache.service.erb'
  $config_filename                    = 'carbon.conf'

  ### carbon::config::cache
  $amqp_exchange                      = 'graphite'
  $amqp_host                          = 'localhost'
  $amqp_metric_name_in_body           = 'False'
  $amqp_password                      = 'guest'
  $amqp_port                          = 5672
  $amqp_verbose                       = 'False'
  $amqp_user                          = 'guest'
  $amqp_vhost                         = '/'
  $bind_patterns                      = undef
  $cache_query_backlog                = undef
  $cache_query_interface              = '0.0.0.0'
  $cache_query_port                   = 7002
  $cache_template                     = 'carbon/etc/carbon/carbon.conf/cache.erb'
  $cache_write_strategy               = 'sorted'
  $carbon_metric_interval             = 60
  $carbon_metric_prefix               = 'carbon'
  $enable_amqp                        = 'False'
  $enable_logrotation                 = 'False'
  $enable_manhole                     = 'False'
  $enable_udp_listener                = 'False'
  $line_receiver_backlog              = undef
  $line_receiver_interface            = '0.0.0.0'
  $line_receiver_port                 = 2203
  $log_cache_hits                     = 'False'
  $log_cache_queue_sorts              = 'True'
  $log_dir                            = '/var/log/carbon'
  $log_listener_connections           = 'True'
  $log_updates                        = 'False'
  $manhole_interface                  = undef
  $manhole_port                       = undef
  $manhole_public_key                 = undef
  $manhole_user                       = 'admin'
  $max_cache_size                     = 'inf'
  $max_creates_per_minute             = 50
  $max_updates_per_second             = 500
  $max_updates_per_second_on_shutdown = undef
  $pickle_receiver_backlog            = undef
  $pickle_receiver_interface          = '0.0.0.0'
  $pickle_receiver_port               = 2204
  $pid_dir                            = '/var/run'
  $storage_dir                        = '/var/lib/carbon'
  $udp_receiver_interface             = '0.0.0.0'
  $udp_receiver_port                  = 2203
  $use_flow_control                   = 'True'
  $use_insecure_unpickler             = 'False'
  $use_whitelist                      = undef
  $whisper_autoflush                  = 'False'
  $whisper_fallocate_create           = 'True'
  $whisper_lock_writes                = undef
  $whisper_sparse_create              = undef
  $whitelists_dir                     = '/var/lib/carbon/lists'
  ### end carbon::config::cache variables.

  ### carbon::install
  $carbon_pkg                         = 'python-carbon'
  $manage_packages                    = true
  $twisted_pkg                        = 'python-twisted-core'
  $whisper_pkg                        = 'python-whisper'
  case $::osfamily {
    'RedHat', 'CentOS': {
      case $::operatingsystemmajrelease {
        /^7$/: {
          $carbon_version   = 'present'
          $twisted_version  = 'present'
          $whisper_version  = 'present'
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
