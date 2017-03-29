class carbon::service (
  $carbon_cache_enabled = $::carbon::carbon_cache_enabled,  
  $carbon_cache_ensure  = $::carbon::carbon_cache_ensure,
  $carbon_relay_enabled = $::carbon::carbon_relay_enabled,
  $carbon_relay_ensure  = $::carbon::carbon_relay_ensure,
  $carbon_caches        = $::carbon::carbon_caches,
  $config_dir           = $::carbon::config_dir,
  $config_filename      = $::carbon::config_filename,
  $log_dir              = $::carbon::log_dir,
  $pid_dir              = $::carbon::pid_dir,
) {
    
  File {
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  $carbon_caches.keys().each |$cache| {
    carbon::cache::service { "carbon-cache-${cache}.service":
      cache           => $cache,
      config_dir      => $config_dir,
      config_filename => $config_filename,
      log_dir         => $log_dir,
      pid_dir         => $pid_dir,
    }
  }

  $carbon_caches.keys().each |$cache| {
    service { "carbon-cache-${cache}":
      name   => "carbon-cache-${cache}",
      enable => $carbon_cache_enabled,
      ensure => $carbon_cache_ensure,
    }
  }

  Carbon::Cache::Service<| |> ~> Service<| |>

  file { "carbon-relay.service":
    content => template('carbon/usr/lib/systemd/system/carbon-relay.service.erb'),
    path    => "/usr/lib/systemd/system/carbon-relay.service",
  }

  service { 'carbon-relay':
    name   => 'carbon-relay',
    enable => $carbon_relay_enabled,
    ensure => $carbon_relay_ensure,
  }

  File['carbon-relay.service'] ~> Service['carbon-relay']

}    
