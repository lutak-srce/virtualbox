#
# = Class: virtualbox
#
# This module manages VirtualBox
#
class virtualbox (
  $major        = '5.0',
  $vboxweb_user = 'vbox',
  $vboxweb_host = '127.0.0.10',
) {
  require admintools::buildchain

  File {
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  package { 'virtualbox':
    ensure => present,
    alias  => 'VirtualBox',
    name   => "VirtualBox-${major}",
  }

  if $vboxweb_user == 'vbox' {
    include virtualbox::user
  }

  file { '/etc/init.d/vboxdrv':
    mode    => '0755',
    source  => 'puppet:///modules/virtualbox/vboxdrv',
    require => Package['virtualbox'],
  }

  file { '/etc/init.d/vboxweb-service':
    mode    => '0755',
    source  => 'puppet:///modules/virtualbox/vboxweb-service',
    require => Package['virtualbox'],
  }

  file { '/etc/sysconfig/virtualbox':
    content => template('virtualbox/virtualbox.erb'),
  }
  file { '/etc/vbox/vbox.cfg':
    ensure  => link,
    target  => '/etc/sysconfig/virtualbox',
    require => Package['virtualbox'],
  }

  exec { 'vboxdrv_setup':
    command => '/etc/init.d/vboxdrv setup',
    unless  => '/etc/init.d/vboxdrv status',
    require => [
      File['/etc/init.d/vboxdrv'],
      File['/etc/vbox/vbox.cfg'],
    ],
  }

  service { 'vboxdrv':
    ensure  => running,
    enable  => true,
    require => [
      File['/etc/init.d/vboxdrv'],
      Exec['vboxdrv_setup'],
    ],
  }

  file { '/var/log/vbox':
    ensure => directory,
    owner  => $vboxweb_user,
    group  => root,
  }

  service { 'vboxweb-service':
    ensure  => running,
    enable  => true,
    require => [
      File['/var/log/vbox'],
      File['/etc/vbox/vbox.cfg'],
      File['/etc/init.d/vboxweb-service'],
    ],
  }

}
