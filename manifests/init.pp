
class iptables (
  $package_name             = $::iptables::package_name,
  $service_name             = $::iptables::service_name,
  $rules_command           =  $::iptables::rules_command,
)

{

  if versioncmp($::puppetversion, '3.6.0') > 0 {
    package { $package_name:
      ensure        => present,
      allow_virtual => false,
    }
  }
  else
  {
    package { $package_name:
      ensure => present,
    }
  }


  Package[$package_name] ->
  service { $service_name:
    ensure     => running,
    enable     => true,
  }


if $rules_command != "" and $rules_command != undef
{
  exec { "iptables":
         command  => $rules_command,
         path     => "${os_path}",
         require  => Package[$package_name],
  } ~>
  exec { "iptables-save":
         command     => "/usr/libexec/iptables/iptables.init save",
         path        => "${os_path}",
  }
}


}