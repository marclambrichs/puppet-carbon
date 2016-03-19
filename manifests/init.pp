# == Class: carbon
#
# Full description of class carbon here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'carbon':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class carbon (
  $gr_carbon_ver      = $carbon::params::gr_carbon_ver,
  $gr_carbon_pkg      = $carbon::params::gr_carbon_pkg,
  $gr_storage_schemas = $carbon::params::gr_storage_schemas,
  $gr_twisted_ver     = $carbon::params::gr_twisted_ver,
  $gr_twisted_pkg     = $carbon::params::gr_twisted_pkg,
  $gr_whisper_ver     = $carbon::params::gr_whisper_ver,
  $gr_whisper_pkg     = $carbon::params::gr_whisper_pkg,
  $manage_packages    = $carbon::params::manage_packages,
) inherits carbon::params {

  validate_bool (
    $manage_packages
  )

  validate_re( $gr_carbon_ver, '^\d+\.\d+\.\d+' )
  validate_re( $gr_twisted_ver, '^\d+\.\d+\.\d+' )
  validate_re( $gr_whisper_ver, '^\d+\.\d+\.\d+' )

  validate_string(
    $gr_carbon_pkg,
    $gr_twisted_pkg,
    $gr_whisper_pkg
  )

  anchor { 'carbon::begin': } ->
  class { 'carbon::install': } ->
  class { 'carbon::config': } ~>
  class { 'carbon::service': } ->
  anchor { 'carbon::end': }
}

