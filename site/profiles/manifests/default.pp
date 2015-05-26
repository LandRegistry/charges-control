# The standard profile for all nodes
class profiles::default {
  include ::standard_env

  service { 'firewalld':
    ensure => 'stopped',
  }
}
