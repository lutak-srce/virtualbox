# Class: virtualbox::extensionpack
#
# This module installs VirtualBox Extension Pack
#
class virtualbox::extensionpack {
  require virtualbox

  $vboxepack="Oracle_VM_VirtualBox_Extension_Pack-${::virtualbox_version}-${::virtualbox_build}.vbox-extpack"

  # after the extpack is installed, vboxdrv and vboxweb-service have to be stopped and cold started
  # for extpack to start working properly again
  exec { 'install_vbox_extensionpack':
    command => "/usr/bin/wget http://download.virtualbox.org/virtualbox/${::virtualbox_version}/${vboxepack} && \
                /usr/bin/VBoxManage extpack install --replace ${vboxepack} && /bin/rm -f ${vboxepack}",
    cwd     => '/tmp',
    unless  => "/usr/bin/VBoxManage list extpacks | /bin/grep 'Revision.*${::virtualbox_build}' > /dev/null 2>&1",
    notify  => Exec['stop_vboxweb'],
  }

  # chain of commands to run after the ExtensionPack installation is finished
  exec { 'stop_vboxweb':
    command     => '/etc/init.d/vboxweb-service stop',
    cwd         => '/tmp',
    refreshonly => true,
    notify      => Exec['stop_vboxdrv'],
  }

  exec { 'stop_vboxdrv':
    command     => '/etc/init.d/vboxdrv stop',
    cwd         => '/tmp',
    refreshonly => true,
    notify      => Exec['start_vboxdrv'],
  }

  exec { 'start_vboxdrv':
    command     => '/etc/init.d/vboxdrv start',
    cwd         => '/tmp',
    refreshonly => true,
    notify      => Exec['start_vboxweb'],
  }

  exec { 'start_vboxweb':
    command     => '/etc/init.d/vboxweb-service start',
    cwd         => '/tmp',
    refreshonly => true,
  }

}
