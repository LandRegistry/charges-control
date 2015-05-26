node default {
  include ::standard_env

  service { 'firewalld':
    ensure => 'stopped',
  }
}

node 'sign' inherits default {
  include ::profiles::borrower_frontend
}
