## Packages to be installed ##
package { 'isc-dhcp-server':
  ensure  => present,
}

package { 'apache2':
  ensure  => present,
}

package { 'tftpd-hpa':
  ensure  => present,
}

package { 'inetutils-inetd':
  ensure  => present,
}

## Mount the Ubuntu ISO and copy files ##
mount { "/mnt":
  device => "/vagrant/ubuntu-14.04.1-server-amd64.iso",
  fstype  => "iso9660",
  options  => "loop,ro",
  ensure  => mounted,
  atboot  => true,
}

## Files to be updated ##
file { '/etc/default/isc-dhcp-server':
  ensure  => present,
  source  => "/vagrant/manifests/templates/isc-dhcp-server",
  require  => Package["isc-dhcp-server"]
}

file { '/etc/dhcp/dhcp.conf':
  ensure  => present,
  source  => "/vagrant/manifests/templates/dhcp.conf",
  require  => Package["isc-dhcp-server"],
  notify  => Service["isc-dhcp-server"]
}

file { "/etc/default/tftpd-hpa":
  ensure  => present,
  require  => Package["tftpd-hpa"],
  source  => "/vagrant/manifests/templates/tftpd-hpa",
}

file { "/etc/inetd.conf":
  ensure  => present,
  require  => Package["inetutils-inetd"],
  source  => "/vagrant/manifests/templates/inetd.conf",
  notify  => Service["tftpd-hpa"]
}

file { "/var/lib/tftpboot/pxelinux.cfg/default":
  ensure  => present,
  source  => "/vagrant/manifests/templates/pxelinux_cfg",
  require  => Package["tftpd-hpa"],
}

file { "/var/lib/tftpboot":
  ensure  => present,
  source  => "/mnt/install/netboot/",
  recurse  => true,
  require  => Mount["/mnt"]
}

file { "/var/www/ubuntu":
  ensure  => "directory",
  source  => "/mnt",
  recurse  => true,
  require  => Mount["/mnt"],
}


## Services to restart ##
service { 'isc-dhcp-server':
  ensure => running,
  enable => true,
}

service { 'tftpd-hpa':
  ensure => running,
  enable => true,
  path  => "/etc/init.d/tftpd-hpa"
}


#mount { "/mnt":
#  ensure  => present,
#  device  => "localhost:/home/sk/ubuntu-14.04-
