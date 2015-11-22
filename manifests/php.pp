# Class: virtualbox::php
#
# This module installs php Virtual Box
#
class virtualbox::php (
  $location              = 'http://127.0.0.10:18083/',
  $noauth                = true,
  $nopreview             = false,
  $previewupdateinterval = '30',
  $consolehost           = $::ipaddress,
){

  package { 'phpvirtualbox':
    ensure => installed,
  }
  file { '/var/www/phpvirtualbox/config.php':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Package['phpvirtualbox'],
    content => template('virtualbox/config.php.erb'),
  }

}
