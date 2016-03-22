#
define carbon::service::instance (){
  service { "carbon-cache-${title}":
    ensure => running,
    enable => true,
  }
}
