class haas::headnode_host (
  $trunk_nic,
  $external_nic,
  $libvirt_bridge = 'virbr0',
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
  sysctl { 'net.ipv4.ip_forward': value => '1' }
  firewall { '100 Allow traffic from the headnodes to the outside world.':
    chain => 'FORWARD',
    iniface => $libvirt_bridge,
    outiface => $external_nic,
    action => 'accept',
  }->
  firewall { '101 Allow existing connections to/from the headnodes.':
    chain => 'FORWARD',
    outiface => $libvirt_bridge,
    state => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
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
