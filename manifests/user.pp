# Class: virtualbox::user
#
# This module manages VirtualBox user
#
class virtualbox::user (
  $password = '',
){

  group { 'vbox':
    ensure => present,
    system => true,
  }
  user { 'vbox':
    ensure     => present,
    gid        => 'vbox',
    password   => $password,
    system     => true,
    home       => '/var/lib/vbox',
    managehome => true,
    shell      => '/bin/bash',
    groups     => ['vboxusers','disk'],
    comment    => 'VirtualBox system user',
    require    => Package['virtualbox'],
  }

# /usr/bin/VBoxManage setproperty websrvauthlibrary null
}
