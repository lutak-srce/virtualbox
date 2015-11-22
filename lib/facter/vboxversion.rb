def get_redhat_virtualbox_version
  version = Facter::Util::Resolution.exec('/bin/rpm -qa | /bin/grep VirtualBox')
  if match = /^VirtualBox-\d\.\d-(\d\.\d\.\d+)_.*$/.match(version)
    match[1]
  else
    nil
  end
end

def get_redhat_virtualbox_build
  build = Facter::Util::Resolution.exec('/bin/rpm -qa | /bin/grep VirtualBox')
  if match = /^VirtualBox-\d\.\d-\d\.\d\.\d+_(\d+)_.*$/.match(build)
    match[1]
  else
    nil
  end
end

Facter.add('virtualbox_version') do
  setcode do
    case Facter.value('osfamily')
      when 'RedHat'
        get_redhat_virtualbox_version()
      else
        nil
    end
  end
end

Facter.add("virtualbox_build") do
  setcode do
    case Facter.value('osfamily')
      when 'RedHat'
        get_redhat_virtualbox_build()
      else
        nil
    end
  end
end
