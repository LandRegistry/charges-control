node default {
  include ::standard_env

  service { 'firewalld':
    ensure => 'stopped',
  }
}

node 'sign' {
  include ::profiles::borrower_frontend
}
