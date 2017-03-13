class carbon::cache::install (
  $config_file = $::carbon::config_file,
  $carbon_ensure = $::carbon::carbon_ensure,
  $carbon_pkg    = $::carbon::carbon_pkg,
  $relay_rules = $::carbon::relay_rules,
  $conf_dir    = $::carbon::carbon_conf_dir,
  $storage_dir = $::carbon::carbon_storage_dir,
  $local_data_dir = $::carbon::local_data_dir,
  $whitelists_dir = $::carbon::whitelists_dir,
  $log_dir = $::carbon::log_dir,
  $pid_dir = $::carbon::pid_dir
) {

  $config_file = "${config_dir}/${config_filename}"

  concat { $config_file:
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('carbon/etc/carbon/carbon.conf.erb'),
  }

  ###
  ### carbon.conf - directories
  ###
  

  file { 'relay-rules.conf':
    path    => "${conf_dir}/relay-rules.conf",
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('carbon/etc/carbon/relay-rules.conf.erb'),
  }

}    
