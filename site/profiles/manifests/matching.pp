# Provides the profile of a box that runs the Charges Matching service
class profiles::matching_service {
  include ::profiles::default
  include ::matching_service
}
