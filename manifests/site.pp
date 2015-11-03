node default {
  include ::profiles::default
}

node 'sign', 'sign.lrdigitalmortgage.com' {
  include ::profiles::sign
}

node 'deedapi' {
  include ::profiles::deedapi
}
