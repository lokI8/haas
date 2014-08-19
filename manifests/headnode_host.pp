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
  }->
  firewall { '102 Deny other traffic to the headnodes (including each other).':
    chain => 'FORWARD',
    iniface => $libvirt_bridge,
    action => 'reject',
  }->
  firewall { '103 Nat traffic from the headnodes.':
    table => 'nat',
    chain => 'POSTROUTING',
    outiface => $external_nic,
    iniface => $libvirt_bridge,
    action => 'masquerade',
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
