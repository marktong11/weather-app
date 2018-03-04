class LocationsController < ApplicationController
	def search
		if params[:search_param].blank?
			flash.now[:danger] = "You have entered an empty search string"
		else
			@location_json = Location.get_json(params[:search_param])
			@location = Location.get_location(@location_json)
			@weather = Location.get_weather(@location_json)
		end

		respond_to do |format|
      format.js { render partial: 'users/result' }
    end
	end

	def weather
			search_string = "#{params[:city]}, #{params[:state]}"
			@location_json = Location.get_json(search_string)
			@location = Location.get_location(@location_json)
			@weather = Location.get_weather(@location_json)

		respond_to do |format|
      format.js { render partial: 'locations/weather' }
    end
	end
end