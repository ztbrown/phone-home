class Tracker < ActiveRecord::Base
  include Tokenable
  include PublicActivity::Common

  belongs_to :user
end
