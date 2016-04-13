# == Class: carbon
#
# Full description of class carbon here.
#
# === Parameters
#
# [*gr_group*]
#   Default: carbon
#
# [*gr_user*]
#   Specify the user to drop privileges to
#   If this is blank carbon runs as the user that invokes it
#   This user must have write access to the local data directory
#
# [*cc_max_cache_size*]
#   Limit the size of the cache to avoid swapping or becoming CPU bound.
#   Sorts and serving cache queries gets more expensive as the cache grows.
#   Use the value "inf" (infinity) for an unlimited cache size.
#
# [*cc_max_updates_per_second*]
#   Limits the number of whisper update_many() calls per second, which
#   effectively means the number of write requests sent to the disk. This is
#   intended to prevent over-utilizing the disk and thus starving the rest of
#   the system.
#   When the rate of required updates exceeds this, then carbon's caching will
#   take effect and increase the overall throughput accordingly.
#
# [*cc_max_creates_per_minute*]
#   Softly limits the number of whisper files that get created each minute.
#   Setting this value low (e.g. 50) is a good way to ensure that your carbon
#   system will not be adversely impacted when a bunch of new metrics are
#   sent to it. The trade off is that any metrics received in excess of this
#   value will be silently dropped, and the whisper file will not be created
#   until such point as a subsequent metric is received and fits within the
#   defined rate limit. Setting this value high (like "inf" for infinity) will
#   cause carbon to create the files quickly but at the risk of increased I/O.
#
# [*cc_enable_logrotation*]
#   Enable daily log rotation. If disabled, carbon will automatically re-open
#   the file if it's rotated out of place (e.g. by logrotate daemon)
#
# [*cc_enable_udp_listener*]
#   Set this to True to enable the UDP listener. By default this is off
#   because it is very common to run multiple carbon daemons and managing
#   another (rarely used) port for every carbon instance is not fun.
#
# [*cc_use_flow_control*]
#   Set this to False to drop datapoints received after the cache
#   reaches MAX_CACHE_SIZE. If this is True (the default) then sockets
#   over which metrics are received will temporarily stop accepting
#   data until the cache size falls below 95% MAX_CACHE_SIZE.
#
# [*cc_log_updates*]
#   By default, carbon-cache will log every whisper update and cache hit. This
#   can be excessive and degrade performance if logging on the same volume as
#   the whisper data is stored.
#
# [*cc_cache_write_strategy*]
#   The thread that writes metrics to disk can use on of the following
#   strategies determining the order in which metrics are removed from cache and
#   flushed to disk. The default option preserves the same behavior as has been
#   historically available in version 0.9.10.
#  
#   sorted - All metrics in the cache will be counted and an ordered list of
#   them will be sorted according to the number of datapoints in the cache at
#   the moment of the list's creation. Metrics will then be flushed from the
#   cache to disk in that order.
#  
#   max - The writer thread will always pop and flush the metric from cache
#   that has the most datapoints. This will give a strong flush preference to
#   frequently updated metrics and will also reduce random file-io. Infrequently
#   updated metrics may only ever be persisted to disk at daemon shutdown if
#   there are a large number of metrics which receive very frequent updates OR
#   if disk i/o is very slow.
#  
#   naive - Metrics will be flushed from the cache to disk in an unordered
#   fashion. This strategy may be desirable in situations where the storage for
#   whisper files is solid state, CPU resources are very limited or deference to
#   the OS's i/o scheduler is expected to compensate for the random write
#   pattern.
#
# [*cc_whisper_autoflush*]
#   On some systems it is desirable for whisper to write synchronously.
#   Set this option to True if you'd like to try this. Basically it will
#   shift the onus of buffering writes from the kernel into carbon's cache.
#
# [*cc_whisper_sparse_create*]
#   By default new Whisper files are created pre-allocated with the data region
#   filled with zeros to prevent fragmentation and speed up contiguous reads and
#   writes (which are common). Enabling this option will cause Whisper to create
#   the file sparsely instead. Enabling this option may allow a large increase
#   of MAX_CREATES_PER_MINUTE but may have longer term performance implications
#   depending on the underlying storage configuration.
#
# [*cc_whisper_fallocate_create*]
#   Only beneficial on linux filesystems that support the fallocate system call.
#   It maintains the benefits of contiguous reads/writes, but with a potentially
#   much faster creation speed, by allowing the kernel to handle the block
#   allocation and zero-ing. Enabling this option may allow a large increase of
#   MAX_CREATES_PER_MINUTE. If enabled on an OS or filesystem that is
#   unsupported this option will gracefully fallback to standard POSIX file
#   access methods.
#
# [*cc_whisper_lock_writes*]
#   Enabling this option will cause Whisper to lock each Whisper file it writes
#   to with an exclusive lock (LOCK_EX, see: man 2 flock). This is useful when
#   multiple carbon-cache daemons are writing to the same files
#
# [*cc_use_whitelist*]
#   Set this to True to enable whitelisting and blacklisting of metrics in
#   CONF_DIR/whitelist and CONF_DIR/blacklist. If the whitelist is missing or
#   empty, all metrics will pass through
#
# [*cc_log_listener_connections*]
#   Set to false to disable logging of successful connections
#
# [* cc_use_insecure_unpickler*]
#   Per security concerns outlined in Bug #  817247 the pickle receiver
#   will use a more secure and slightly less efficient unpickler.
#   Set this to True to revert to the old-fashioned insecure unpickler.
#
# [*cc_pickle_receiver_backlog*]
# Set the TCP backlog for the listen socket created by the pickle receiver. You
# shouldn't change this unless you know what you're doing.
#
# [*cc_max_updates_per_second_on_shutdown*]
#   If defined, this changes the MAX_UPDATES_PER_SECOND in Carbon when a
#   stop/shutdown is initiated.  This helps when MAX_UPDATES_PER_SECOND is
#   relatively low and carbon has cached a lot of updates; it enables the carbon
#   daemon to shutdown more quickly.
#
# [*cc_line_receiver_backlog*]
#   Set the TCP backlog for the listen socket created by the line receiver. You
#   shouldn't change this unless you know what you're doing.
#   LINE_RECEIVER_BACKLOG = 1024
#
# [*cc_cache_query_backlog*]
#   Set the TCP backlog for the listen socket created by the cache query
#   listener. You shouldn't change this unless you know what you're doing.
#   CACHE_QUERY_BACKLOG = 1024
#
# [*cc_carbon_metric_prefix*]
#   By default, carbon itself will log statistics (such as a count,
#   metricsReceived) with the top level prefix of 'carbon' at an interval of 60
#   seconds. Set CARBON_METRIC_INTERVAL to 0 to disable instrumentation
#
# [*cc_enable_amqp*]
#   Enable AMQP if you want to receve metrics using an amqp broker
#
# [*cc_enable_manhole*]
#   The manhole interface allows you to SSH into the carbon daemon
#   and get a python interpreter. BE CAREFUL WITH THIS! If you do
#   something like time.sleep() in the interpreter, the whole process
#   will sleep! This is *extremely* helpful in debugging, assuming
#   you are familiar with the code. If you are not, please don't
#   mess with this, you are asking for trouble :)
#
# [*cc_amqp_verbose*]
#   Verbose means a line will be logged for every metric received
#   useful for testing
#
# [*cc_bind_patterns*]
#   Patterns for all of the metrics this machine will store. Read more at
#   http://en.wikipedia.org/wiki/Advanced_Message_Queuing_Protocol#  Bindings
#     Example: store all sales, linux servers, and utilization metrics
#     BIND_PATTERNS = sales.#  , servers.linux.#  , #  .utilization
#     Example: store everything
#     BIND_PATTERNS = #  
#
# [*cc_manhole_interface*]
#   Default: '127.0.0.1'
#
# [*cc_manhole_port*]
#   Default: 7222
#
# [*cc_manhole_user*]
#   Default: 'admin'
#
# [*cc_manhole_public_key*]
#
# [*gr_enable_carbon_cache*]
#   Whether carbon cache should be enabled to start at boot.
#   Type: Boolean
#   Default: true
#
# [*gr_ensure_carbon_cache*]
#   Whether a service should be running.
#   Type: Boolean
#   Default: true
#
# === Variables
#
# === Examples
#
#  class { 'carbon':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Marc Lambrichs <marc.lambrichs@gmail.com>
#
# === Copyright
#
#
class carbon (
  ### general
  $carbon_caches                      = $carbon::params::carbon_caches,
  $config_dir                         = $carbon::params::config_dir,
  $enable_carbon_cache                = $carbon::params::enable_carbon_cache,
  $group                              = $carbon::params::group,
  $user                               = $carbon::params::user,
  $local_data_dir                     = $carbon::params::local_data_dir,
  $systemd_dir                        = $carbon::params::systemd_dir,

  ### carbon::service
  $ensure_carbon_cache                = $carbon::params::ensure_carbon_cache,

  ### carbon::config
  $cache_service_template             = $carbon::params::cache_service_template,
  $config_filename                    = $carbon::params::config_filename,
  $storage_aggregations               = $carbon::params::storage_aggregations,
  $storage_schemas                    = $carbon::params::storage_schemas,

  ### carbon::config::cache variables
  $amqp_exchange                      = $carbon::params::amqp_exchange,
  $amqp_host                          = $carbon::params::amqp_host,
  $amqp_metric_name_in_body           = $carbon::params::amqp_metric_name_in_body,
  $amqp_password                      = $carbon::params::amqp_password,
  $amqp_port                          = $carbon::params::amqp_port,
  $amqp_user                          = $carbon::params::amqp_user,
  $amqp_verbose                       = $carbon::params::amqp_verbose,
  $amqp_vhost                         = $carbon::params::amqp_vhost,
  $bind_patterns                      = $carbon::params::bind_patterns,
  $cache_query_backlog                = $carbon::params::cache_query_backlog,
  $cache_query_interface              = $carbon::params::cache_query_interface,
  $cache_query_port                   = $carbon::params::cache_query_port,
  $cache_template                     = $carbon::params::cache_template,
  $cache_write_strategy               = $carbon::params::cache_write_strategy,
  $carbon_metric_interval             = $carbon::params::carbon_metric_interval,
  $carbon_metric_prefix               = $carbon::params::carbon_metric_prefix,
  $enable_amqp                        = $carbon::params::enable_amqp,
  $enable_logrotation                 = $carbon::params::enable_logrotation,
  $enable_manhole                     = $carbon::params::enable_manhole,
  $enable_udp_listener                = $carbon::params::enable_udp_listener,
  $line_receiver_backlog              = $carbon::params::line_receiver_backlog,
  $line_receiver_interface            = $carbon::params::line_receiver_interface,
  $line_receiver_port                 = $carbon::params::line_receiver_port,
  $log_cache_hits                     = $carbon::params::log_cache_hits,
  $log_cache_queue_sorts              = $carbon::params::log_cache_queue_sorts,
  $log_dir                            = $carbon::params::log_dir,
  $log_listener_connections           = $carbon::params::log_listener_connections,
  $log_updates                        = $carbon::params::log_updates,
  $manhole_interface                  = $carbon::params::manhole_interface,
  $manhole_port                       = $carbon::params::manhole_port,
  $manhole_public_key                 = $carbon::params::manhole_public_key,
  $manhole_user                       = $carbon::params::manhole_user,
  $max_cache_size                     = $carbon::params::max_cache_size,
  $max_creates_per_minute             = $carbon::params::max_creates_per_minute,
  $max_updates_per_second             = $carbon::params::max_updates_per_second,
  $max_updates_per_second_on_shutdown = $carbon::params::max_updates_per_second_on_shutdown,
  $pickle_receiver_backlog            = $carbon::params::pickle_receiver_backlog,
  $pickle_receiver_interface          = $carbon::params::pickle_receiver_interface,
  $pickle_receiver_port               = $carbon::params::pickle_receiver_port,
  $pid_dir                            = $carbon::params::pid_dir,
  $storage_dir                        = $carbon::params::storage_dir,
  $udp_receiver_interface             = $carbon::params::udp_receiver_interface,
  $udp_receiver_port                  = $carbon::params::udp_receiver_port,
  $use_flow_control                   = $carbon::params::use_flow_control,
  $use_insecure_unpickler             = $carbon::params::use_insecure_unpickler,
  $use_whitelist                      = $carbon::params::use_whitelist,
  $whisper_autoflush                  = $carbon::params::whisper_autoflush,
  $whisper_fallocate_create           = $carbon::params::whisper_fallocate_create,
  $whisper_lock_writes                = $carbon::params::whisper_lock_writes,
  $whisper_sparse_create              = $carbon::params::whisper_sparse_create,
  $whitelists_dir                     = $carbon::params::whitelists_dir,
  ### end carbon::config::cache variables.

  ### carbon::install
  $carbon_pkg                         = $carbon::params::carbon_pkg,
  $carbon_version                     = $carbon::params::carbon_version,
  $manage_packages                    = $carbon::params::manage_packages,
  $twisted_pkg                        = $carbon::params::twisted_pkg,
  $twisted_version                    = $carbon::params::twisted_version,
  $whisper_pkg                        = $carbon::params::whisper_pkg,
  $whisper_version                    = $carbon::params::whisper_version,
) inherits carbon::params {

  ### define complete path config file
  $config_file = "${config_dir}/${config_filename}"

  validate_absolute_path( $config_dir )
  validate_absolute_path( $systemd_dir )
  validate_absolute_path( $local_data_dir )
  validate_absolute_path( $log_dir )
  validate_absolute_path( $pid_dir )
  validate_absolute_path( $storage_dir )
  validate_absolute_path( $whitelists_dir )

  validate_array( $storage_aggregations )
  validate_array( $storage_schemas )

  validate_bool (
    $manage_packages
  )

  validate_hash( $carbon_caches )

  if $cache_query_backlog {
    validate_integer($cache_query_backlog)
  }
  if $line_receiver_backlog {
    validate_integer($line_receiver_backlog)
  }
  if $pickle_receiver_backlog {
    validate_integer($pickle_receiver_backlog)
  }

  validate_re( $amqp_metric_name_in_body, 'False|True' )
  validate_re( $amqp_verbose, 'False|True' )
  validate_re( $enable_amqp, 'False|True' )
  validate_re( $enable_logrotation, 'False|True' )
  validate_re( $enable_udp_listener, 'False|True' )
  validate_re( $log_cache_hits, 'False|True' )
  validate_re( $log_cache_queue_sorts, 'False|True' )
  validate_re( $log_listener_connections, 'False|True' )
  validate_re( $log_updates, 'False|True' )
  validate_re( $use_flow_control, 'False|True' )
  validate_re( $use_insecure_unpickler, 'False|True' )
  validate_re( $whisper_autoflush, 'False|True' )
  validate_re( $whisper_fallocate_create, 'False|True' )

  validate_re( $carbon_version, '^(present|\d+\.\d+\.\d+)$' )
  validate_re( $ensure_carbon_cache, '^(running|stopped)$')
  validate_re( $twisted_version, '^(present|\d+\.\d+\.\d+)$' )
  validate_re( $whisper_version, '^(present|\d+\.\d+\.\d+)$' )

  validate_string(
    $amqp_exchange,
    $amqp_host,
    $amqp_user,
    $cache_write_strategy,
    $carbon_metric_prefix,
    $carbon_pkg,
    $config_file,
    $twisted_pkg,
    $user,
    $whisper_pkg
  )

  anchor { 'carbon::begin': } ->
  class { 'carbon::install': } ->
  class { 'carbon::config': } ~>
  class { 'carbon::service': } ->
  anchor { 'carbon::end': }
}
