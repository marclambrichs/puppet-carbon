# == Class carbon::config

class carbon::config {

  file {
    '/etc/carbon/storage-schemas.conf':
      ensure  => file,
      content => template('carbon/etc/carbon/storage-schemas.conf.erb'),
      mode    => '0644'
  }
}
