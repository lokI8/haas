class haas::headnode_host (
  $trunk_nic,
  $dev_mode = false,
) {
  if $::operatingsystem != 'CentOS' {
    fail('Only CentOS headnode hosts are supported!')
  }
  include epel
  package {
    [
      'libvirt',
      'libvirt-client',
      'python-virtinst',
      'vconfig',
      'bridge-utils',
      'telnet',
      'qemu-kvm',
    ] :
    ensure => present,
  }
  service { 'libvirtd':
    ensure => running,
    enable => true,
  }
  if $dev_mode {
    package {
      [
        'gcc',
        'git',
        'python-virtualenv',
      ] :
      ensure => present,
    }
  }
}
