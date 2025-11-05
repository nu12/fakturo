class GuestController < ApplicationController
  allow_unauthenticated_access only: %i[ policy ]

  def policy
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Data & Privacy policy" } ]
    @active = "policy"
    render "policy", layout: authenticated? ? "application" : "guest"
  end
end
