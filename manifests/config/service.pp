#
define carbon::config::service () {
  file { "carbon-cache-${title}.service":
    ensure  => file,
    content => template('carbon/usr/lib/systemd/system/carbon-cache.service.erb'),
    group   => 'root',
    mode    => '0755',
    owner   => 'root',
    path    => "/usr/lib/systemd/system/carbon-cache-${title}.service",
  }
}
