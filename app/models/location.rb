class Location < ApplicationRecord
	require 'open-uri'
	has_many :user_locations
	has_many :users, through: :user_locations

	def self.get_json(search_param)
		base_url = 'https://query.yahooapis.com/v1/public/yql'
		query = "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text='#{search_param}')&format=json"
		query_url = "#{base_url}?q=#{query}"

		json = open(query_url).read
		looked_up_location = JSON.parse(json)	
	end

	def self.find_by_city_and_region(city, region)
		base_url = 'https://query.yahooapis.com/v1/public/yql'
		query = "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text='#{city}, #{region}')&format=json"
		query_url = "#{base_url}?q=#{query}"

		json = open(query_url).read
		looked_up_location = JSON.parse(json)	
	end

	def self.get_location(looked_up_location)
		if has_results?(looked_up_location)
			city = get_city(looked_up_location)
			region = get_region(looked_up_location)
			country = get_country(looked_up_location)

			new(city: city, region: region, country: country)
		end
	end

	def self.get_weather(looked_up_location)
		weather = {}
		weather["temp_current"] = get_current_temp(looked_up_location)
		weather["temp_high"] = get_high_temp(looked_up_location)
		weather["temp_low"] = get_low_temp(looked_up_location)
		weather["temp_average"] = get_average_temp(looked_up_location)
		weather
	end

	def self.has_results?(looked_up_location)
		looked_up_location["query"]["count"] > 0
	end

	def self.get_city(looked_up_location)
		 looked_up_location["query"]["results"]["channel"]["location"]["city"]
	end

	def self.get_region(looked_up_location)
		looked_up_location["query"]["results"]["channel"]["location"]["region"]
	end

	def self.get_country(looked_up_location)
		looked_up_location["query"]["results"]["channel"]["location"]["country"]
	end

	def self.get_current_temp(looked_up_location)
		looked_up_location["query"]["results"]["channel"]["item"]["condition"]["temp"]
	end

	def self.get_high_temp(looked_up_location)
		looked_up_location["query"]["results"]["channel"]["item"]["forecast"][0]["high"]
	end

	def self.get_low_temp(looked_up_location)
		looked_up_location["query"]["results"]["channel"]["item"]["forecast"][0]["low"]
	end

	def self.get_average_temp(looked_up_location)
		(looked_up_location["query"]["results"]["channel"]["item"]["forecast"][0]["high"].to_f + 
			looked_up_location["query"]["results"]["channel"]["item"]["forecast"][0]["low"].to_f) / 2
	end

end
