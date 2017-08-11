#
# = Class: virtualbox
#
# This module manages VirtualBox
#
class virtualbox (
  $version = '5.1',
  $license = '_please_create_license_',
) {

  File {
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  package { 'VirtualBox':
    ensure => present,
    name   => "VirtualBox-${version}",
  }

  $vboxepack="Oracle_VM_VirtualBox_Extension_Pack-${::virtualbox_version}-${::virtualbox_build}.vbox-extpack"

  exec { 'install_vbox_extensionpack':
    command => "/usr/bin/wget http://download.virtualbox.org/virtualbox/${::virtualbox_version}/${vboxepack} && \
                /usr/bin/VBoxManage extpack install --replace ${vboxepack} --accept-license=${license} \
		&& /bin/rm -f ${vboxepack}",
    cwd     => '/tmp',
    unless  => "/usr/bin/VBoxManage list extpacks | /bin/grep 'Revision.*${::virtualbox_build}' > /dev/null 2>&1",
    require => Package['VirtualBox'],
  }

}
