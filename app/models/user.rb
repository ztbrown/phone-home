class User < ActiveRecord::Base
  include Gravtastic

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  gravtastic rating: 'R'

  has_many :trackers
end
