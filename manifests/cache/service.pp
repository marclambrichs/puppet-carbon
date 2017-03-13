define carbon::cache::service (
  $cache,
  $config_dir,
  $config_filename,
  $log_dir,
  $pid_dir,
) {

  file { "carbon-cache-${cache}.service":
    content => template('carbon/usr/lib/systemd/system/carbon-cache.service.erb'),
    path    => "/usr/lib/systemd/system/carbon-cache-${cache}.service",
  }
}
