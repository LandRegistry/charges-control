node default {
  include ::profiles::default
}

node 'sign', 'ip-10-85-1-204' {
  include ::profiles::sign
}

node 'deed' {
  include ::profiles::deed
}
