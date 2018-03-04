class UserLocationsController < ApplicationController
	def create
		location_json = Location.find_by_city_and_region(params[:city], params[:region])
		looked_up_location = Location.get_location(location_json)
		location = Location.where(city: looked_up_location.city, region: looked_up_location.region)

		if location.blank?
			looked_up_location.save
		end

		@user_location = UserLocation.create(user: current_user, location: looked_up_location)
		flash.now[:success] = "Location #{@user_location.location.city}, #{@user_location.location.region} was successfully added to your list"
		redirect_to my_locations_path
	end

	def destroy
		@user_location = UserLocation.where(user_id: current_user.id, location_id: params[:id]).first
		@user_location.destroy
		flash.now[:notice] = "Location was successfully removed"
		redirect_to my_locations_path
	end
end
