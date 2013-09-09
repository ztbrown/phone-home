class Ability
  include CanCan::Ability

  def initialize(user)
    # Only registered users:
    if user.persisted?

      ## Abilities go here

      can [:index, :create, :destroy], Tracker

    end
  end
end
