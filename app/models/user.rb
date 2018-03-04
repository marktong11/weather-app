class User < ApplicationRecord
	has_many :user_locations
	has_many :locations, through: :user_locations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def has_location?(city, region)
		user_locations.joins(:location).where(locations: { city: city, region: region }).count > 0
	end
end
