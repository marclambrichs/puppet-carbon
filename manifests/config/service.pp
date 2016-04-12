# == type carbon::config::service
#
#
define carbon::config::service (
  $template,
  $systemd_dir,
) {
  file { "carbon-cache-${title}.service":
    ensure  => file,
    content => template("carbon${systemd_dir}/${template}"),
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
    path    => "${systemd_dir}/carbon-cache-${title}.service",
  }
}
