# == Class: carbon::install
#
# === Parameters
#
# @param carbon_ensure
# @param carbon_pkg
# @param manage_pkg
# @param group
# @param user
#
class carbon::install (
  $carbon_ensure        = $::carbon::carbon_ensure,
  $carbon_pkg           = $::carbon::carbon_pkg,
  $manage_pkg           = $::carbon::manage_pkg,
  $group                = $::carbon::group,
  $user                 = $::carbon::user,
) {

  group { $group:
    ensure => present,
  }

  -> user { $user:
    ensure => present,
    groups => $group,
  }

  if $manage_pkg {
    package { $carbon_pkg:
      ensure => $carbon_ensure,
      name   => $carbon_pkg,
    }
  }

}
