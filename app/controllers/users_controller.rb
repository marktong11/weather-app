class UsersController < ApplicationController
	def my_locations
		@user = current_user
		@user_locations = current_user.locations
	end
end