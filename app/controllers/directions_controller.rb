require 'open-uri'

class DirectionsController < ApplicationController
  def get
    #GOOGLE_MAPS_API_KEY = 'AIzaSyATapwAT6x09jbq8xi1tG3_DrhYultpLb4'    
    url = "http://maps.googleapis.com/maps/api/directions/json?"

    @params = params.to_s
    message = params[:message]
    from, to = message.scan(/.*?from\s(.*)\sto\s(.*)/).first

    url << "origin=#{from}"
    url << "&destination=#{to}"
    url << "&sensor=false"

    p url

    directions = JSON.parse(open(URI::encode url).read)
    legs = directions['routes'].first['legs'].first

    distance = legs['distance']['text']
    duration = legs['duration']['text']
    steps = legs['steps']

    steps.map! do |step|
      { distance_to: step['distance']['text'],
        name: HTMLEntities.new.decode(step['html_instructions'].gsub(/<.*?>/, '').squeeze(' '))
      }
    end

    @data = { distance: distance, duration: duration, steps: steps }

    respond_to do |format|
      format.html
      format.text do
        steps.map! do |step|
          "#{step[:distance_to]} - #{step[:name]}"
        end
        render :text => "Distance is #{distance} and duration is #{duration}.\n#{steps.join("\n")}"
      end
    end
  end
end
