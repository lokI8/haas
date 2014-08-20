# Copyright 2014 Massachusetts Open Cloud Contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an "AS
# IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied.  See the License for the specific language
# governing permissions and limitations under the License.
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
