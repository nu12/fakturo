class GuestController < ApplicationController
  layout "guest"
  allow_unauthenticated_access only: %i[ policy ]

  def policy
  end
end
