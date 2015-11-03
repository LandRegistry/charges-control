node default {
  include ::profiles::default
}

node 'sign', 'ip-192-168-248-71' {
  include ::profiles::sign
}

node 'deedapi' {
  include ::profiles::deedapi
}
