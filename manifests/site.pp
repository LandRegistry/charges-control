node default {
  include ::standard_env
}

node 'sign' {
  include ::profiles::borrower_frontend
}
