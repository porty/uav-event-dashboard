class EventsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    events = params["events"]

    transmission = EventTransmission.new
    transmission.timestamp = params["time"].to_datetime.to_i
    transmission.save!

    events.each do |e|
      event = Event.new
      event.event_type = e["type"]
      event.timestamp = e["time"].to_datetime.to_i
      event.data = e["data"].to_json
      event.event_transmission_id = transmission.id
      event.save!
      begin
        event.process!
      rescue StandardError => e
       # TODO bugsnag or sentry or something
       Rails.logger.error('Failed to process event')
       Rails.logger.error(e.message)
       Rails.logger.error(e.backtrace)
      end
    end

    render json: {}, status_code: 201
  end

end
