node default {
  include ::profiles::default
}

node 'sign', 'ip-10-85-1-204' {
  include ::profiles::sign
}

node 'deedapi' {
  include ::profiles::deedapi
}

node 'case' {
  include ::profiles::case
}

node 'scribeapi' {
  include ::profiles::scribeapi
}

node 'caseapi' {
  include ::profiles::caseapi
}

node 'verifudge', 'verifudge.lrdigitalmortgage-int.com' {
  include ::profiles::verifudge
}

node 'matching' {
  include ::profiles::matching_service
}

node 'catalogue' {
  include ::profiles::catalogue
}
