# Provides the profile of a box that runs the Charges Deed Api
class profiles::deedapi {
  include ::profiles::default
  include ::deed_api
}
