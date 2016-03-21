# == Class: carbon
#
# Full description of class carbon here.
#
# === Parameters
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
# Copyright 2016 Melange IT B.V.
#
class carbon (
  $cc_amqp_exchange                      = $carbon::params::cc_amqp_exchange,
  $cc_amqp_host                          = $carbon::params::cc_amqp_host,
  $cc_amqp_metric_name_in_body           = $carbon::params::cc_amqp_metric_name_in_body,
  $cc_amqp_port                          = $carbon::params::cc_amqp_port,
  $cc_amqp_verbose                       = $carbon::params::cc_amqp_verbose,
  $cc_amqp_user                          = $carbon::params::cc_amqp_user,
  $cc_amqp_vhost                         = $carbon::params::cc_amqp_vhost,
  $cc_bind_patterns                      = $carbon::params::cc_bind_patterns,
  $cc_cache_query_backlog                = $carbon::params::cc_cache_query_backlog,
  $cc_cache_query_interface              = $carbon::params::cc_cache_query_interface,
  $cc_cache_write_strategy               = $carbon::params::cc_cache_write_strategy,
  $cc_carbon_caches                      = $carbon::params::cc_carbon_caches,
  $cc_carbon_metric_interval             = $carbon::params::cc_carbon_metric_interval,
  $cc_carbon_metric_prefix               = $carbon::params::cc_carbon_metric_prefix,
  $cc_enable_amqp                        = $carbon::params::cc_enable_amqp,
  $cc_enable_logrotation                 = $carbon::params::cc_enable_logrotation,
  $cc_enable_manhole                     = $carbon::params::cc_enable_manhole,
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
  $cc_manhole_interface                  = $carbon::params::cc_manhole_interface,
  $cc_manhole_port                       = $carbon::params::cc_manhole_port,
  $cc_manhole_user                       = $carbon::params::cc_manhole_user,
  $cc_manhole_public_key                 = $carbon::params::cc_manhole_public_key,
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

  validate_array( $cc_storage_schemas )

  validate_bool (
    $gr_enable_carbon_relay,
    $manage_packages
  )

  validate_hash( $cc_carbon_caches )

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
